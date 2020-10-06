module.exports = {
  // plugins: [['@babel/plugin-transform-typescript', { allowNamespaces: true }]],
  plugins: ['babel-plugin-typescript-strip-namespaces'],
  presets: ['babel-preset-gatsby'],
};
