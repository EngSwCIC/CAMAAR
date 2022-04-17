import { createApp } from "vue";
import { createPinia } from "pinia";
import App from "./App.vue";
import router from "./router";

import "./index.css";
import "vue-toastification/dist/index.css";

import Toast from "vue-toastification";
import { useToast } from "vue-toastification";
import axios from "axios";

import VueChartkick from 'vue-chartkick'
import 'chartkick/chart.js'

const toast = useToast();
const pinia = createPinia();
const app = createApp(App);
app.use(pinia);
app.use(router);
app.use(Toast);
app.use(VueChartkick);

app.config.globalProperties.$notify = toast;
app.config.globalProperties.$axios = axios;

router.isReady().then(() => {
  app.mount("#app");
});
