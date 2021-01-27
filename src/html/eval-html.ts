import { DocPrecursor, Html } from '@friends-library/types';
import { Parser, traverse, DocumentNode } from '@friends-library/parser';
import visitor from './html-visitor';

export default function evalHtml(
  dpc: DocPrecursor,
): { chapters: Html[]; document: DocumentNode } {
  const document = Parser.parseDocument(...dpc.asciidocFiles) as DocumentNode;
  // document.print();
  const chapters: Array<string[]> = [];
  traverse(document, visitor, chapters, {});
  return {
    chapters: chapters.map((ch) => ch.join(``)),
    document,
  };
}
