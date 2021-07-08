//--------------------------------------------
var ReportPrepareData = function(th, data) {
    let Table, Rows, Cols, tmpName,
        Totals, curNode, DefCols,
        FormRows, FormColumns, Summary,
        chgGroup;

    DefCols = new mtools.DefCols();
    Table = data.Table;
    Rows = data.Rows;
    Cols = data.Cols;
    Totals = data.Totals;
    FormRows = data.FormRows;
    FormColumns = data.FormColumns;

//            FormProps = data.FormProps;
    if(Cols.length > 0) {
        Summary = new mtools.SummaryCols( Totals );
        tmpName = Cols[0].name.map( () => { return null; } );
//       Добавление колонок для строк
        FormRows.forEach((r, k) => {
            DefCols.AddColumn(0, r.title_, r.props_).props.prop = 'rc' + k;
//      Дабовление в таблице данных с наименованиями строк (декодирование строк)
            Table.forEach((p, i) => {
                let j;
                j = (p.r1 === Rows[i].key_out) ? i : _.findIndex(Rows, {"key_out": p.r1});
                if (j >= 0) eval('p.rc'+k+' = Rows[j].name[0]');
            });
        });
//       Формирование описания колонок
        Cols.forEach((p, i) => {
            if((chgGroup = Summary.TestNextData(p.key_in)) != null) {
                Summary.PushColumns(chgGroup, Table, DefCols);
//                        console.log(chgGroup);
            }
            p.name.forEach( (nameCol, j) => {
                if(tmpName[j] !== nameCol) {
                    curNode = DefCols.AddColumn(j, nameCol, FormColumns[j].props_);
                    tmpName[j] = nameCol;
                }
            });
            curNode.props.prop = 'c' + p.key_out;

            Summary.PutNextData(p);
        });
        Summary.PushColumns(-1, Table, DefCols);
//              console.log(DefCols);
    }
    return DefCols.DC;
}

module.exports = ReportPrepareData;
