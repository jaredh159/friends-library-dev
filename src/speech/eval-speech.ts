import { DocPrecursor, Html } from '@friends-library/types';
import { Parser, traverse } from '@friends-library/parser';
import visitor from './speech-visitor';

export function toSpeechText(dpc: DocPrecursor): string {
  const document = Parser.parseDocument(...dpc.asciidocFiles);
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

export function toSpeechHtml(dpc: DocPrecursor): Html {
  return `
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>${dpc.meta.title}</title>
</head>
<body>
${toSpeechText(dpc).trim().replace(/\n/g, `<br />`)}
</body>
</html>
`;
}
