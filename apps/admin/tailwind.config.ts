import { tailwindPreset } from '@friends-library/theme';

/** @type {import('tailwindcss').Config} */
export default {
  presets: [tailwindPreset()],
  content: [`./build/**/*.html`, `./src/**/*.{ts,tsx,html}`],
  plugins: [require(`@tailwindcss/forms`)],
  theme: {
    extend: {
      animation: { 'spin-fast': `spin 0.75s ease-in-out infinite` },
    },
  },
};
