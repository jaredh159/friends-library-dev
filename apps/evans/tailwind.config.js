// @ts-check
const { tailwindPreset } = require(`@friends-library/theme`);

const lang = process.env.GATSBY_LANG === `es` ? `es` : `en`;

module.exports = {
  presets: [tailwindPreset(lang)],
  content: [`./src/**/*.tsx`],
};
