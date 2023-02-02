import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    host: `localhost`,
    port: 5757,
    strictPort: true,
    open: false,
  },
  build: {
    outDir: `dist`,
  },
  preview: {
    port: 5757,
  },
  plugins: [react()],
});
