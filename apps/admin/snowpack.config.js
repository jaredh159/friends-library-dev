// @see: https://www.snowpack.dev/reference/configuration
/** @type {import("snowpack").SnowpackUserConfig } */
module.exports = {
  mount: {
    src: `/`,
  },
  plugins: [`@snowpack/plugin-postcss`, `@snowpack/plugin-dotenv`],
  packageOptions: {
    types: true,
    knownEntryPoints: [`@apollo/client/link/context`],
  },
  devOptions: {
    port: 5757,
    open: `none`,
    tailwindConfig: `./tailwind.config.js`,
  },
  routes: [
    {
      match: `routes`,
      src: `.*`,
      dest: `/index.html`,
    },
  ],
  buildOptions: {},
};
