const { getTailwindConfig } = require(`@friends-library/theme`);

module.exports = {
  ...getTailwindConfig(`en`),
  purge: false,
};
