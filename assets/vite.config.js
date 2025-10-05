import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig(({ mode }) => ({
  plugins: [vue()],   // 👈 This line enables .vue SFC support
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
