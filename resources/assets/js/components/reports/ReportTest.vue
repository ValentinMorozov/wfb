<template>
    <div>
        <p>
            Проверка расширений!
        </p>
        <cross-table :Columns="defColumns"
                     :TabProp="propTable"
                     :TabData="dataTable">
        </cross-table>
        <slot></slot>
    </div>
</template>

<script>

  import crossTable from './crossTable.vue';
  export default {
  name: 'ReportTest',
  componentName: 'ReportTest',
  extends: crossTable,

  data: function () {
    return {
        XX: 0
    }
  }

};
</script>
