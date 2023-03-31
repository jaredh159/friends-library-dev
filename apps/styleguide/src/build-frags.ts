import * as fs from 'fs';
import path from 'path';
import { sync as glob } from 'glob';
import chokidar from 'chokidar';
import throttle from 'lodash.throttle';
import { genericDpc } from '@friends-library/types';
import { paperbackInterior } from '@friends-library/doc-css';
import { evaluate, ParserError } from '@friends-library/evaluator';

const notify = throttle(
  () => process.stdout.write(`🚁 \x1b[35mstyleguide fragments regenerated\x1b[0m\n`),
  5000,
);

const adocGlob = `${__dirname}/adoc/*.adoc`;

if (process.argv.includes(`--watch`)) {
  chokidar.watch(adocGlob).on(`all`, regen);
} else {
  regen();
}

function regen(): void {
  fs.writeFileSync(
    `${__dirname}/paperback-interior.css`,
    paperbackInterior({ runningHeadTitle: ``, printSize: `m`, numFootnotes: 10 }).replace(
      `background: url(line.svg)`,
      `_background: url(line.svg)`,
    ) +
      `
      html,
      body {
        margin: 0;
      }
      html {
        font-size: 19px;
        box-sizing: border-box;
      }
      *,
      *:before,
      *:after {
        box-sizing: inherit;
      }
      .rendered-adoc .chapter,
      .rendered-adoc .epigraphs {
        margin-top: 0 !important;
      }
      #generated .chapter-heading {
        display: none;
      }\n`,
  );
  const files = glob(adocGlob);
  const frags: { [k: string]: { html: string; adoc: string } } = {};

  files.forEach((file) => {
    const adoc = normalizeAdoc(fs.readFileSync(file).toString());
    const dpc = genericDpc();
    dpc.asciidocFiles = [{ adoc, filename: file }];
    try {
      var result = evaluate.toPdfSrcHtml(dpc);
    } catch (err) {
      if (err instanceof ParserError) {
        // eslint-disable-next-line no-console
        console.log(err.codeFrame);
        process.exit(1);
      } else {
        throw err;
      }
    }
    const id = path.basename(file).replace(/\.adoc$/, ``);

    frags[id] = {
      html: `${result.epigraphHtml}${result.mergedChapterHtml()}`,
      adoc,
    };
  });

  fs.writeFileSync(`${__dirname}/built-frags.json`, JSON.stringify(frags));
  notify();
}

function normalizeAdoc(adoc: string): string {
  if (adoc.match(/(^|\n)== /)) {
    return adoc;
  }
  if (!adoc.includes(`[quote.epigraph`)) {
    return `[#generated]\n== Generated\n\n${adoc}`;
  } else {
    return `${adoc}\n[#generated]\n== Generated\n`;
  }
}
