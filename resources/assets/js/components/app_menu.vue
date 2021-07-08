// resources/assets/js/components/app_menu.vue

<template>
    <el-menu :default-active="activeIndex" class="el-menu-demo" mode="horizontal" @select="handleSelect"  @click="handleClick">
        <slot> </slot>
    </el-menu>
</template>
<script>
  export default {
    name: 'AppMenu',
    componentName: 'AppMenu',
    data() {
      return {
        activeIndex: 'X',
        activeIndex2: 'Y'
      };
    },
    methods: {
      handleSelect(key, keyPath) {
          let form_id = 0;
          form_id = eval(key);
          this.$bus.$emit("ReportSelectForm", { form_id: form_id });
//        console.log(key, keyPath);
      },
      handleClick(menu_item) {
            console.log(menu_item);
        }

    }
  };
</script>

