import { tailwindPreset } from '@friends-library/theme';

const lang = process.env.GATSBY_LANG === `es` ? `es` : `en`;

/** @type {import('tailwindcss').Config} */
export default {
  presets: [tailwindPreset(lang)],
  content: [`./src/**/*.tsx`],
};
