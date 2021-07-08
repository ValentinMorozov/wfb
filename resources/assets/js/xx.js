'use strict';

window.AppComponents.Init.push(function(Vue) {
    Vue.component('FormReport', require('./components/reports/report.vue'));
});




PrepareData: function(th, data) {
    let Table, Rows, Cols, tmpName, laval,
        curPath, curNode, DefCols,
        FormRows, FormColumns, Summary;

    Summary = new mtools.SummaryCols();
    Summary.AddGroup(0, [1, 2], null);


//            console.log(Summary.Test());

    DefCols = {};
    Table = data.Table;
    Rows = data.Rows;
    Cols = data.Cols;
    FormRows = data.FormRows;
    FormColumns = data.FormColumns;
//            FormProps = data.FormProps;
    if(Cols.length > 0) {

        DefCols.columns = [];
        tmpName = [];
        curPath = [];
        curPath[0] = DefCols;
        Cols[0].name.forEach(() => { tmpName.push(null); return; });

//       Добавление колонок для строк
        FormRows.forEach((r, k) => {
            let n, DC = DefCols.columns;
            DC.push( { columns: [] } );
            n = DC.length - 1;
            if(typeof r.props_ && r.props_ !== null)
                DC[n].props = r.props_;
            else DC[n].props = {};
            DC[n].props.label = r.title_;
            DC[n].props.prop = 'rc' + k;
//      Дабовление в таблице данных с наименованиями строк (декодирование строк)
            Table.forEach((p, i) => {
                    let j;
                    if (p.r1 === Rows[i].key_out) j = i;
                    else j = _.findIndex(Rows, {"key_out": p.r1});
                    if (j >= 0) eval('p.rc'+k+' = Rows[j].name[0]');
                }
            );
        });
//       Формирование описания колонок
        Cols.forEach((p, i) => {

            p.name.forEach( (nameCol, j) => {
                let n;
                curNode = curPath[j];
                if(tmpName[j] !== nameCol)
                {
                    curNode.columns.push({ columns: [] });
                    n = curNode.columns.length - 1;
                    curNode.columns[n].props = (typeof FormColumns[j].props_ && FormColumns[j].props_ !== null) ?
                        _.cloneDeep(FormColumns[j].props_) : {};
                    curNode.columns[n].props.label = nameCol;

                    curPath[j+1] = curNode.columns[n];
                    tmpName[j] = nameCol;
                }
                else curNode = curPath[j];
            });
            curNode.props.prop = 'c' + p.key_out;
            Summary.PutNextData(p);
        });
//              console.log(DefCols);
    }
    return DefCols;
}
}
};
