//--------------------------------------------
var SummaryCols = function (defTotals) {
    let p_obj;
    this.SummaryGroup = [];
    this.keyFuncs = [];
    this.totalFuncs = [];
    this.nColumn = 0;

    this.keyFuncs['default'] = function(key) { return key; } ;                              // Функция нормализации ключа по умолчанию
    defTotals.functions.keyFuncs.forEach((p) => {                                           // Копирование из описания функций нормализации ключа
        this.keyFuncs[p.name] = new Function('key', p.body);
    });

    this.totalFuncs['default'] = function(previousValue, currentValue) {                    // Функция подсчета итогов по умолчанию
                                return previousValue + currentValue; } ;
    defTotals.functions.totalFuncs.forEach((p) => {                                         // Копирование из описания функций подсчета итогов
        this.totalFuncs[p.name] = new Function('previousValue, currentValue, index, array', p.body);
    });
//
    defTotals.groups.forEach((p) => {                                                       // Копирование групп итогов
        let levelGroup = p.level >= 0 ? p.level : 9;
        if(typeof p.slices.length && p.slices.length > 0) {
            this.SummaryGroup[levelGroup] = {};
            p_obj = this.SummaryGroup[levelGroup];
            p_obj.funcKey = this.keyFuncs[(typeof p.funcKey !== "undefined") ? p.funcKey : 'default'];
            p_obj.titleLevel = (typeof p.titleLevel !== "undefined") ? p.titleLevel : p.level + 1;          // Вычисление уровня отображения заголовка
            p_obj.title = (typeof p.title !== "undefined") ? p.title : null;
            p_obj.props = (typeof p.props !== "undefined") ? p.props : {};

            p_obj.slices = p.slices.map( (s) => {                                           // Настройка параметров срезов
                let funcKey = this.keyFuncs[(typeof s.funcKey !== "undefined") ? s.funcKey : 'default'],
                    funcTotal = this.totalFuncs[(typeof s.funcTotal !== "undefined") ? s.funcTotal : 'default'],
                    props = (typeof s.props !== "undefined") ? s.props : {} ;
                return { level: s.level,
                         funcKey: funcKey,
                         funcTotal: funcTotal,
                         props: props,
                         values: [] };
            });
            p_obj.oldValue = null;
        }
    });

}
//
SummaryCols.prototype.TestNextData = function(array_keys) {
    var key_in,
        changes = null,
        p_obj;
    this.SummaryGroup.forEach((p, k) => {
        if(k < 9) {                                               // Пропустить проверку для тотальных итогов
            p_obj = this.SummaryGroup[k];
            key_in = p_obj.funcKey(array_keys[k]);
// Проверка на изменение группы
            if (key_in != p_obj.oldValue) {
                if (p_obj.oldValue !== null) changes = k;
                p_obj.oldValue = key_in;
            }
        }
    });
    return changes;
}
//
// key_out композитный ключ колонки
SummaryCols.prototype.PutNextData = function(column) {
    var key_in_, name,
        array_keys = column.key_in;
    var i, l = array_keys.length - 1;
    for (i = 0; i < l; i++){
        key_in_ = array_keys[i];
        name = column.name[i];
        this.SummaryGroup.forEach((grp) => {         // Перебор групп итогов
            grp.slices.forEach((slc, k) => {        // Перебор срезов в группах
                let idx, key_in;
                if(slc.level === i) {               // Срез соответствует типу ключа
                    key_in = slc.funcKey(key_in_);
                    idx = _.findIndex(slc.values, {"key_in": key_in } );
                    if (idx < 0) {
                        slc.values.push({"key_in": key_in, name: key_in == key_in_ ? name : key_in, columns: [] });
                        idx = slc.values.length - 1;
                    }
                    slc.values[idx].columns.push(column.key_out);
                }
            });
        });
    }
    return;
}
//
SummaryCols.prototype.PushColumns = function(level, Table, DefCols) {  // (level, oldValue)
    let p_obj,
        columnLevel,
        arrayToOut;

    arrayToOut = this.SummaryGroup.map((p, i) => { return i === 9 ? -1 : i; } )
                                  .filter((k) => k >= level)
                                  .sort((a, b) =>  b - a)
                                  .map((i) => { return i === -1 ? 9 : i; } ); // Подготовка порядка обхода групп итогов
    arrayToOut.forEach((n) => {
        p_obj = this.SummaryGroup[n];
        p_obj.oldValue = null;//oldValue;
        columnLevel = p_obj.titleLevel;
        if (p_obj.title !== null) {
            DefCols.AddColumn(columnLevel, p_obj.title, p_obj.props );       // Заголовок для итогов
            columnLevel++;
        }
        p_obj.slices.forEach((slc, i) => {                                   // Перебор срезов в группе
            let slice = slc;
            slc.values.forEach((vls, j) => {                                 // Перебор значений группировок
                let columnName = 'tot' + (this.nColumn++);
                let NameCols = vls.columns.map((c) => 'c' + c);
//            console.log('Колонки ',vls.name, NameCols);
                Table.forEach((p, k) => {
                    let total = NameCols.map((c) => {
                        let x = p[c];
                        return (typeof x === 'undefined') ? 0 : _.toNumber(x);
                    }).reduce(slice.funcTotal);
                    p[columnName] = (total !== 0) ? total : '';
//                console.log('Значения ',k, array_val, p[columnName]);
                });
                DefCols.AddColumn(columnLevel, vls.name, slice.props).props.prop = columnName;
                vls.columns = [];
            });
            slc.values = [];
        });
    });
    return;
}
//

module.exports = SummaryCols;
