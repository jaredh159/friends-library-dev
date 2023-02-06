import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// https://vitejs.dev/config/
export default defineConfig({
  server: {
    host: `localhost`,
    port: 7373,
    strictPort: true,
    open: false,
  },
  build: {
    outDir: `dist`,
  },
  preview: {
    port: 7373,
  },
  plugins: [react()],
});
