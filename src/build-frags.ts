import fs from 'fs';
import path from 'path';
import { sync as glob } from 'glob';
import chokidar from 'chokidar';
import throttle from 'lodash/throttle';
import { Html, Asciidoc } from '@friends-library/types';
import { processDocument } from '@friends-library/adoc-convert';
import { genericPaperbackInterior } from '@friends-library/doc-css';
import { webHtml, epigraph } from '@friends-library/doc-html';

const notify = throttle(
  () => console.log(`🚁 \x1b[35mstyleguide fragments regenerated\x1b[0m`),
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
    genericPaperbackInterior().replace(
      `background: url(line.svg)`,
      `_background: url(line.svg)`,
    ),
  );
  const files = glob(adocGlob);
  const frags: { [k: string]: { html: Html; adoc: Asciidoc } } = {};

  files.forEach((file) => {
    const adoc = normalizeAdoc(fs.readFileSync(file).toString());
    const { sections, epigraphs } = processDocument(adoc);
    const id = path.basename(file).replace(/\.adoc$/, ``);

    frags[id] = {
      html: `${epigraph({ epigraphs })}${webHtml(sections)}`,
      adoc,
    };
  });

  fs.writeFileSync(`${__dirname}/built-frags.json`, JSON.stringify(frags));
  notify();
}

function normalizeAdoc(adoc: Asciidoc): Asciidoc {
  if (adoc.match(/(^|\n)== /)) {
    return adoc;
  }

  return `== Generated\n\n${adoc}`;
}
