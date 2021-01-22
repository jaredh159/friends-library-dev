import { DocPrecursor } from '@friends-library/types';
import { Parser, traverse } from '@friends-library/parser';
import visitor from './visitor';

export default function compile(dpc: DocPrecursor): string {
  const document = Parser.parseDocument(...dpc.asciidocFiles);
  const lines: string[] = [];
  traverse(document, visitor, lines, { dpc });
  return lines.join(`\n`);
}
