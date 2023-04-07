const { tailwindPreset } = require(`@friends-library/theme`);

const preset = { ...tailwindPreset() };

preset.theme.extend.animation = { 'spin-fast': `spin 0.75s ease-in-out infinite` };

module.exports = {
  presets: [preset],
  content: [`./build/**/*.html`, `./src/**/*.{ts,tsx,html}`],
  plugins: [require(`@tailwindcss/forms`)],
};
