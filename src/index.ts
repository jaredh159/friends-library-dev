import { DocPrecursor } from '@friends-library/types';
import { Parser, traverse } from '@friends-library/parser';
import visitor from './visitor';

export default function compile(dpc: DocPrecursor): string {
  const document = Parser.parseDocument(...dpc.asciidocFiles);
  // document.print();
  const lines: string[] = [];
  traverse(document, visitor, lines, { dpc });
  return lines
    .reduce((doc, line, idx) => {
      // prevent more than 2 line breaks in a row
      const join = line === `` && lines[idx - 1] === `` ? `` : `\n`;
      return `${doc}${join}${line.trimStart()}`;
    }, ``)
    .trim();
}
