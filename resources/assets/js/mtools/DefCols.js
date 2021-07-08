//--------------------------------------------
var DefCols = function () {
    this.DC = {};
    this.DC.columns = [];
    this.curLevel = 0;
    this.curPath = [];
    this.curPath[0] = this.DC;
}
//
DefCols.prototype.AddColumn = function(level, label, props) {
    let cur, n;
    if(level >= 0) this.curLevel = level;
    cur = this.curPath[this.curLevel].columns
    cur.push( { columns: [] } );
    n = cur.length - 1;
    cur[n].props = (typeof props && props !== null) ? _.cloneDeep(props) : {};
    cur[n].props.label = label;
    this.curPath[this.curLevel + 1] = cur[n];
    return cur[n];
}


module.exports = DefCols;
