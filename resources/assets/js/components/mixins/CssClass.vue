<script>
export default {
  data: function () {
    return {
        WidthClassName:'',
        HightClassName:'',
        ColorClassName:'',
        OtherClassName:''
    }
  },
  computed: {
    cssClass: function () {
        return this.OtherClassName + this.WidthClassName + this.HightClassName  + this.ColorClassName;
    }
  },
 created: function () {
    this.$cssClass = {};
    this.$cssClass.Width = this.$root.$_sess.cssClasses.cssWidth;
     console.log('mixin-Css');
  }
};
</script>

