import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    host: `localhost`,
    port: 9999,
    strictPort: true,
    open: false,
  },
  build: {
    outDir: `dist`,
    chunkSizeWarningLimit: 100000000,
  },
  preview: {
    port: 9999,
  },
  plugins: [react()],
});
