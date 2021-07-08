export default {
props: {
    Columns: Object,
    TabProp: Object,
    TabData: Array
},
  data: function () {
    return {
        defColumns: this.Columns,
        propTable: this.TabProp,
        dataTable: this.TabData
    }
  }
};
