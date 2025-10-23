import { defineConfig } from 'vitest/config';
import vue from '@vitejs/plugin-vue';
import path from 'path';
import VueI18nPlugin from '@intlify/unplugin-vue-i18n/vite';

const proxyObject = {
  target: 'http://localhost:8080',
  ws: true,
  changeOrigin: true,
};

export default defineConfig({
  plugins: [
    vue(),
    VueI18nPlugin({
      include: path.resolve(__dirname, './src/plugins/i18n/locales/**'),
      strictMessage: false,
    }),
  ],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  server: {
    proxy: {
      '/api': proxyObject,
      '/config': proxyObject,
    },
  },
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: `@import "@/assets/variables.scss";`,
      },
    },
  },
  test: {
    globals: true,
    setupFiles: ['/test/setupGlobalMocks.ts', '/test/setupApi.ts'],
    environment: 'jsdom',
  },

  // 🔹 Add this build config
  base: '/tenant-ui/',
  build: {
    outDir: 'dist',       // ensures the output goes to dist/
    emptyOutDir: true,    // cleans dist before building
    rollupOptions: {
      input: path.resolve(__dirname, 'src/index.html'), // main entry file
      output: {
        assetFileNames: 'assets/[name]-[hash][extname]',
        chunkFileNames: 'assets/[name]-[hash].js',
        entryFileNames: 'assets/[name]-[hash].js',
      },
    },
  },
});
