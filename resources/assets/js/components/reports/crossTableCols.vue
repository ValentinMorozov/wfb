// resources/assets/js/components/reports/reportCols.vue

<script>
  export default {
      name: 'CrossTableCols',
      componentName: 'CrossTableCols',
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
                  return createElement('cross-table-cols', { props: { pcols: p, pcounter: this.counter} })
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
