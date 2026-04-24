import { createApp, h } from "vue";
import { createInertiaApp } from "@inertiajs/vue3";
import { InertiaProgress } from "@inertiajs/progress";
import axios from "axios";
import "../css/main.css";

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  ?.getAttribute("content");

if (csrfToken) {
  axios.defaults.headers.common["x-csrf-token"] = csrfToken;
}

axios.defaults.headers.common["x-requested-with"] = "XMLHttpRequest";

InertiaProgress.init();

const pages = import.meta.glob("./Pages/**/*.vue");

createInertiaApp({
  resolve: (name) => {
    const importPage = pages[`./Pages/${name}.vue`];

    if (!importPage) { throw new Error(`Page not found: ${name}`);}

    return importPage().then((module) => module.default);
  },
  setup({ el, App, props }) {
    createApp({ render: () => h(App, props) }).mount(el);
  },
});
