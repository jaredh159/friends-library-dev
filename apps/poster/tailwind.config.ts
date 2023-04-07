// @ts-check
import { tailwindPreset } from '@friends-library/theme';

const lang = process.env.LANG === `es` ? `es` : `en`;

/** @type {import('tailwindcss').Config} */
export default {
  presets: [tailwindPreset(lang)],
  content: [
    `./src/**/*.tsx`,
    `../evans/src/components/LogoAmigos.tsx`,
    `../evans/src/components/LogoFriends.tsx`,
    `../evans/src/components/Album.tsx`,
  ],
};
