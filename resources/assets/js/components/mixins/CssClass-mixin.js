export default {
  data: function () {
    return {
        ClassName: {}
    }
  },
    computed: {
        cssClass: function () {
            return this.$root.$_sess.cssClasses.ToString(this.ClassName);
        },
        isAdminDB: function () {
            return this.$root.$_sess.isAdminDB();
        }
    },
    created: function () {
        this.$cssClass = {};
        this.$cssClass.Width = this.$root.$_sess.cssClasses.cssWidth;
        this.RootURL = function () { return this.$root.$_sess.RootURL; }
    }
};


