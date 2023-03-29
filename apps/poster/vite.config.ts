import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    host: `localhost`,
    port: 3535,
    strictPort: true,
    open: false,
  },
  build: {
    outDir: `dist`,
  },
  preview: {
    port: 3535,
  },
  plugins: [react()],
  define: {
    'process.env': {},
  },
  resolve: {
    alias: {
      evans: `${__dirname}/../evans/src`,
    },
  },
});
