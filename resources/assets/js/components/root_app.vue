// resources/assets/js/components/root_app.vue 
<template>
    <div @click.capture="click">
        <slot></slot>
    </div>
</template>

<script>
    export default {
    props: { cursiteurl: String ,
             superadmin: { Boolean, default : false },
             csrftoken: String
           },
    data: function () {
        return {
          open: false

        }
    },
    mounted: function() {

    },
    created: function() {
         var sess = this.$root.$_sess;
         sess.RootURL = this.cursiteurl;
         sess.isSuperAdmin = Boolean(this.superadmin);
         sess.CSRFToken = this.csrftoken;
         sess.isAdminDB = function () {
                return sess.isSuperAdmin;
         };
         this.axios.defaults.headers.common = {
                'X-Requested-Width': 'XMLHttpRequest',
                'X-CSRF-TOKEN': sess.CSRFToken
              };
    },
    beforeDestroy: function() {

    },
    methods: {
        click: function (event) {

            },
        handleClick(param) {
            console.log(this.$options._componentTag, param);
        }
      }
    }
</script>
