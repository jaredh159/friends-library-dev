import { tailwindPreset } from '@friends-library/theme';

/** @type {import('tailwindcss').Config} */
export default {
  presets: [tailwindPreset(`en`)],
  content: [
    `./src/**/*.tsx`,
    `../evans/src/**/*.tsx`,
    `../../libs-ts/cover-component/src/**/*.tsx`,
  ],
};
