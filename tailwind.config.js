const { getTailwindConfig } = require(`@friends-library/theme`);

module.exports = {
  mode: `jit`,
  purge: [`./build/**/*.html`, `./src/**/*.{ts,tsx,html}`],
  ...getTailwindConfig(),
};
