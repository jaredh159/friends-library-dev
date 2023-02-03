// @ts-check
const { getTailwindConfig } = require(`@friends-library/theme`);

const lang = process.env.LANG === `es` ? `es` : `en`;

module.exports = {
  ...getTailwindConfig(lang),
  purge: [`./src/**/*.tsx`],
};
