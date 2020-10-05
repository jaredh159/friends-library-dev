// @ts-check
const fs = require(`fs`);
const { genericPaperbackInterior: css } = require(`@friends-library/doc-css`);

fs.writeFileSync(`${__dirname}/preview.css`, css());
