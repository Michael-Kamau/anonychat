import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import tailwindcss from '@tailwindcss/vite';


export default defineConfig(({ mode }) => ({
  plugins: [vue(), tailwindcss()],   
  root: ".",
  base: mode === "development" ? "/" : "/assets/",
  server: {
    port: 5173,
    strictPort: true,
    origin: "http://localhost:5173",
    hmr: { host: "localhost" }
  },
  build: {
    manifest: true,
    outDir: "../priv/static/assets",
    assetsDir: "",
    rollupOptions: {
      input: "/js/app.js"
    }
  }
}));
