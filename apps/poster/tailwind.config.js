// @ts-check
const { tailwindPreset } = require(`@friends-library/theme`);

const lang = process.env.LANG === `es` ? `es` : `en`;

module.exports = {
  presets: [tailwindPreset(lang)],
  content: [
    `./src/**/*.tsx`,
    `../evans/src/components/LogoAmigos.tsx`,
    `../evans/src/components/LogoFriends.tsx`,
    `../evans/src/components/Album.tsx`,
  ],
};
