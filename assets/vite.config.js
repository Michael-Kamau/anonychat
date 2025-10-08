import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import tailwindcss from '@tailwindcss/vite';
import path from 'node:path';
import { fileURLToPath, URL } from 'node:url';

 
  


export default defineConfig(({ mode }) => {

  const isDev = mode !== 'build';

// Alias target for assets (differs in dev vs build)
  let assetUrl = fileURLToPath(new URL('../../priv/static/assets', import.meta.url));

  if (isDev) {
    // Terminate the watcher when Phoenix quits
    process.stdin.on('close', () => {
      process.exit(0);
    });
    process.stdin.resume();

    assetUrl = fileURLToPath(new URL('./assets', import.meta.url));
  }


  return {
  plugins: [vue(), tailwindcss()],   
  root: ".",
  base: mode === "development" ? "/" : "/assets/",
  server: {
    port: 5173,
    strictPort: true,
    origin: "http://localhost:5173",
    hmr: { host: "localhost" }
  },
  resolve: {
      alias: {
        '@': fileURLToPath(new URL('.', import.meta.url)),
        assets: assetUrl
      }
    },
   build: {
    outDir: path.resolve(__dirname, '../priv/static/assets'),
    emptyOutDir: true,
    sourcemap: true,
    cssCodeSplit: false,     // bundle CSS into a single file
    rollupOptions: {
      input: path.resolve(__dirname, 'js/app.js'),
      output: {
        entryFileNames: 'app.js',     // /assets/app.js
        assetFileNames: 'app.[ext]',  // /assets/app.css (and any other assets)
        chunkFileNames: 'chunks/[name].js'
      }
    }
  }
};
});
