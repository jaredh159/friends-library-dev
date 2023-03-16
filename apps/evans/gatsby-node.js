require(`ts-node`).register();

exports.sourceNodes = require(`./src/ssg/source-nodes`).default;
exports.createPagesStatefully = require(`./src/ssg/create-pages-statefully`).default;
exports.createPages = require(`./src/ssg/create-pages`).default;
exports.onCreatePage = require(`./src/ssg/on-create-page`).default;
exports.onCreateDevServer = require(`./src/ssg/on-create-dev-server`).default;
exports.onPostBuild = require(`./src/ssg/on-post-build`).default;
exports.createSchemaCustomization =
  require(`./src/ssg/create-schema-customization`).default;
