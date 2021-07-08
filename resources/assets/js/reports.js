'use strict';

window.AppComponents.Init.push(function(Vue) {
    Vue.component('CrossTable', require('./components/reports/crossTable.vue'));
    Vue.component('CrossTableCols', require('./components/reports/crossTableCols.vue'));
    Vue.component('ReportTest', require('./components/reports/ReportTest.vue'));
});

