'use strict';


require('./bootstrap');

window.mtools = require('./mtools/mtools');

window.Vue = require('vue');

import ElementUI from 'element-ui';
import locale from 'element-ui/lib/locale/lang/ru-RU';
Vue.use(ElementUI, { locale });
/*import 'element-theme-default';*/


import axios from 'axios';
import VueAxios from 'vue-axios';

Vue.use(VueAxios, axios);


Vue.component('RootApp', require('./components/root_app.vue'));
Vue.component('AppMenu', require('./components/app_menu.vue'));
Vue.component('AppWrap', require('./components/appWrap.vue'));
Vue.component('AppContent', require('./components/appContent.vue'));
import Session from './components/mixins/session.js';

window.AppComponents.Init.forEach((item) => item(Vue));

// Централизованная шина событий
Object.defineProperty(Vue.prototype,"$bus",{
    get: function() {
        return this.$root.bus
    }
});

const app = new Vue({
    mixins: [Session],
    el: '#app',
    data: { bus: new Vue({}) },
    created: function () {
    }
});