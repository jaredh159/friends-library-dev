const { getTailwindConfig } = require(`@friends-library/theme`);

const config = getTailwindConfig();

config.theme.extend.animation = { 'spin-fast': `spin 0.75s ease-in-out infinite` };

module.exports = {
  mode: `jit`,
  purge: [`./build/**/*.html`, `./src/**/*.{ts,tsx,html}`],
  ...config,
  plugins: [require(`@tailwindcss/forms`)],
};
