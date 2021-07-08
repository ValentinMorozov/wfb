// resources/assets/js/components/reports/report.vue

<script>
import mixCssClass from '../mixins/CssClass-mixin.js';
//--------------------------------------------
export default {
    name: 'FormReport',
    componentName: 'FormReport',
    mixins: [mixCssClass],
    props: { Columns: Object,
             PropForm: Object,
             TabData: Array
    },
    data() {
      return {
        defColumns: this.Columns,
        propFromDB: this.PropForm,
        TableData: this.TabData,
//        isLoading: false,
        id:0
      };
    },
    render: function (createElement) {
        let th = this,
            tb_options = {};
        tb_options.style = { width: "100%" };
        tb_options.props = (typeof th.propFromDB && th.propFromDB !== null) ?
                            _.cloneDeep(th.propFromDB) : {};
        tb_options.props.data = this.TableData;
        return createElement('div', {
                class: "cssClass"
            },
            [  createElement('el-table', tb_options ,
                 [
                    createElement('el-table-column', {}),
                    createElement('form-report-cols', { props: {pcols: this.defColumns, pcounter: 0} })
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
