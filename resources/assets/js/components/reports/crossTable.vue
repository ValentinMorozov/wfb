// resources/assets/js/components/reports/report.vue

<script>
import mixCssClass from '../mixins/CssClass-mixin.js';
import mixReportProps from '../mixins/ReportProps-mixin.js';
//--------------------------------------------
export default {
    name: 'CrossTable',
    componentName: 'CrossTable',
    mixins: [mixCssClass, mixReportProps],
/*    props: { Columns: Object,
             TabProp: Object,
             TabData: Array
    },*/
    data() {
      return {
/*        defColumns: this.Columns,
        propTable: this.TabProp,
        dataTable: this.TabData,
*/
//        isLoading: false,
        id:0
      };
    },
    render: function (createElement) {
        let th = this,
            tb_options = {};
//let xx = th.testParentMethod();
        tb_options.style = { width: "100%" };
        tb_options.props = (typeof th.propTable && th.propTable !== null) ?
                            _.cloneDeep(th.propTable) : {};
        tb_options.props.data = this.dataTable;
        return createElement('div', {
                class: "cssClass"
            },
            [  createElement('el-table', tb_options ,
                 [
                    createElement('el-table-column', {}),
                    createElement('cross-table-cols', { props: {pcols: this.defColumns, pcounter: 0} })
                 ])
            ])
    },

    created: function() {
        this.ClassName['Other'] = "report-form";
    },

    computed: {
        dialogFormVisible() {
            return true;
        }

    }
    /*,
    methods: {
        testParentMethod() {
            let aa =  mtools.ParentMethod(this, 'handleClick', 1);
            if(aa)  {
                aa.method.call(aa.th, 'call');

                this.handleClick = _.bind(aa.method, aa.th);
                this.handleClick('lodash');

            }
            return aa;
        }
    }*/
  };
</script>

<style>
.report-form {
    float: right;
    padding: 0;
    border-bottom: 1px solid;
}
table.el-table__body, table.el-table__footer {
    text-align: right;
}

</style>
