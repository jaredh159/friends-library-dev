const { getTailwindConfig } = require(`@friends-library/theme`);

module.exports = {
  ...getTailwindConfig(`en`),
  content: [
    `./src/**/*.tsx`,
    `../evans/src/**/*.tsx`,
    `../../libs-ts/cover-component/src/**/*.tsx`,
  ],
};
