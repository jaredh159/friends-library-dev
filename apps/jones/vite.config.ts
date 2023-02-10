import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    host: `localhost`,
    port: 8888,
    strictPort: true,
    open: false,
  },
  build: {
    outDir: `dist`,
  },
  preview: {
    port: 8888,
  },
  plugins: [react()],
  define: {
    // https://github.com/bevacqua/dragula/issues/602
    global: {},
    process: { env: {} },
  },
  resolve: {
    alias: {
      'node-fetch': `isomorphic-fetch`,
    },
  },
});
