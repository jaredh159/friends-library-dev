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
  },
  preview: {
    port: 9999,
  },
  plugins: [react()],
});
