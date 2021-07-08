
<template>
    <div class="appwrap">
        <app-content v-if="notEmpty" :res-data="ResponseData" :frm-id="FormID">

        </app-content>
    <slot></slot>
    </div>
</template>

<script>
/*
<template>
    <div class="appwrap">
        <app-content v-if="notEmpty" :res-data="ResponseData" :frm-id="FormID">

        </app-content>
    <slot></slot>
    </div>
</template>
*/
  import mixCssClass from './mixins/CssClass-mixin.js';
  export default {
  name: 'appWrap',
  componentName: 'appWrap',
  mixins: [mixCssClass],
  data: function () {
    return {
        ResponseData: Object,
        FormID: 0,
        isLoading: false
    };
  },

  computed: {
      notEmpty() {
          return this.FormID;
      }
  },
  mounted: function() {
      var th = this;
      this.$el.className = this.$el.className.replace(/(?:^|\s)visible_off03(?!\S)/g,' visible_on03 ');
      this._otherEvent = (event) => {
          let id = event.form_id;
          th.LoadData(th, id);
          return;
      }
      this.$bus.$on("ReportSelectForm", this._otherEvent);
  },
  beforeDestroy: function() {
      this.$bus.$off("ReportSelectForm", this._otherEvent);
  },
  methods: {
      LoadData: function(th, id) {
          if(th.isLoading == false && id > 0) {
              var AjaxURL = this.RootURL() + '/ajax/getdata';
              th.isLoading = true;
              const formData = new FormData();

              formData.append( 'form_id', JSON.stringify(id));

              th.axios.post(AjaxURL, formData)
                  .then(response => {
                      th.ResponseData = response.data;
                      th.FormID = id;
                      th.isLoading = false;
                  })
                  .catch(response => {
                      console.log('catch');
                      th.isLoading = false;
                  });
              th.FormID = 0;
              this.isVisible = true;            // ???
          }
          return;
      }
  }
};
</script>
