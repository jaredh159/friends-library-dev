import path from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  resolve: {
    alias: {
      '@evans': path.resolve(__dirname, `../evans/src/components/`),
    },
  },
});
