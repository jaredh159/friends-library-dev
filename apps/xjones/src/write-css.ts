import * as fs from 'fs';
import { paperbackInterior as css } from '@friends-library/doc-css';

fs.writeFileSync(
  `${__dirname}/preview.css`,
  css({
    runningHeadTitle: `Preview`,
    printSize: `m`,
    numFootnotes: 10,
  }),
);
