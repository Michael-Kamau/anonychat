import { createApp, h } from "vue";
import { createInertiaApp } from "@inertiajs/vue3";
import { InertiaProgress } from "@inertiajs/progress";

InertiaProgress.init();

const pages = import.meta.glob("./Pages/**/*.vue");

console.log("Available pages:", Object.keys(pages));


createInertiaApp({
  resolve: (name) => {
    const importPage = pages[`./Pages/${name}.vue`];
    if (!importPage) throw new Error(`Page not found: ${name}`);
    return importPage().then((m) => m.default);
  },
  setup({ el, App, props }) {
    createApp({ render: () => h(App, props) }).mount(el);
  },
});
