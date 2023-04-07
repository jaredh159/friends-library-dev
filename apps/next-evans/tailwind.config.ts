import { tailwindPreset } from '@friends-library/theme';

const lang = process.env.NEXT_PUBLIC_LANG === `es` ? `es` : `en`;

/** @type {import('tailwindcss').Config} */
export default {
  presets: [tailwindPreset(lang)],
  content: [`./pages/**/*.{ts,tsx}`, `./components/**/*.{ts,tsx}`, `./app/**/*.{ts,tsx}`],
};
