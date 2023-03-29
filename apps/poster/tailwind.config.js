// @ts-check
const { getTailwindConfig } = require(`@friends-library/theme`);

const lang = process.env.LANG === `es` ? `es` : `en`;

module.exports = {
  content: [
    `./src/**/*.tsx`,
    `../evans/src/components/LogoAmigos.tsx`,
    `../evans/src/components/LogoFriends.tsx`,
    `../evans/src/components/Album.tsx`,
  ],
  ...getTailwindConfig(lang),
};
