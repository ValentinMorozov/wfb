<script>
  import mixCssClass from './mixins/CssClass-mixin.js';
  export default {
  name: 'appContent',
  componentName: 'appContent',
  mixins: [mixCssClass],
//  functional: true,
  props: { ResData: Object,
           FrmId: Number
  },
  data: function () {
      return {
          ResponseData: this.ResData,
          FormID: this.FrmId
      };
  },
  created: function () {
        this.ClassName['Other'] = "appbox";
  },
  render: function (createElement) {
      let array_el = [],
          defColumns,
          p_obj,
          th = this,
          rp_options = {};
      p_obj = th.ResponseData;
      defColumns = mtools.PrepareData(th, p_obj);
      rp_options.props = { Columns: defColumns, TabProp: p_obj.FormProps, TabData: p_obj.Table };

//      rp_options.props.TabProp.rowClassName = _.bind(th.testParentMethod, th);
//      rp_options.props.TabProp.rowClassName = function() { console.log('Так'); return ''; } ;

      return createElement('div', {
              class: "appbox"
          }, [
              createElement(_.kebabCase(p_obj.FormComponent.replace('default', 'ReportTest'/*'CrossTable'*/)), rp_options, th.$slots.default )
             ]
      );
  },
  computed: {
      notEmpty() {
          return this.FormID;
      }
  }
 /* ,
  methods: {
      testParentMethod() {
          console.log('Есть контакт ', this.$options._componentTag);

          let aa =  mtools.ParentMethod(this, 'handleClick', 1);
          if(aa)  {
              aa.method.call(aa.th, 'call');

              this.handleClick = _.bind(aa.method, aa.th);
              this.handleClick('lodash');

          }
          return "";
      }
  }
*/
};
</script>
