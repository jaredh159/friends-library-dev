const { tailwindPreset } = require(`@friends-library/theme`);

module.exports = {
  presets: [tailwindPreset(`en`)],
  content: [
    `./src/**/*.tsx`,
    `../evans/src/**/*.tsx`,
    `../../libs-ts/cover-component/src/**/*.tsx`,
  ],
};
