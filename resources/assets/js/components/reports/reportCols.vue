// resources/assets/js/components/reports/reportCols.vue

<script>
/*
<template>
        <div v-if="!pcounter">
            <form-report-cols  v-for="item_col in pcols.columns"
                               :pcols="item_col" :pcounter="counter" :key="keyCalc">
            </form-report-cols>
        </div>
        <el-table-column v-else
                :label="pcols.label"
                :prop="pcols.prop">
            <form-report-cols  v-for="item_col in pcols.columns"
                               :pcols="item_col" :pcounter="counter" :key="keyCalc">
            </form-report-cols>
        </el-table-column>
</template>
*/
  export default {
      name: 'FormReportCols',
      componentName: 'FormReportCols',
      props: {
          pcols: Object,
          pcounter: Number
      },
      data() {
          return {
              counter: this.pcounter + 1
          };
      },
      render: function (createElement) {
          let th = this,
              el_tag,
              el_options = {};
          if(this.pcounter) {
              el_tag = 'el-table-column';
              el_options.props = th.pcols.props;
          }
          else el_tag = 'div';
          return createElement(el_tag, el_options,
              this.pcols.columns.map(function (p) {
                  return createElement('form-report-cols', { props: { pcols: p, pcounter: this.counter} })
              }, th))
      },
      computed: {
          isGroup: function () {
                 // return this.pcols.columns && this.pcols.columns.length;                     prop="cols.prop"
              return !this.pcols.prop;
          },
          keyCalc: function () {
              this.counter += 1;
              return "RF" + this.counter;
          },
          isFirst: function () {
              return this.counter === 0;
          }
      }
  };
</script>

<style>

</style>
