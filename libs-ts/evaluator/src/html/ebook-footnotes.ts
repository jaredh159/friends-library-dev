import { Lang } from '@friends-library/types';
import {
  AstNode,
  traverse,
  DocumentNode,
  Node,
  NODE as n,
} from '@friends-library/parser';
import visitor from './EbookFootnoteContentVisitor';
import { footnoteCallMarkup, footnoteMarker } from './FootnoteVisitor';

export default function evalEbookFootnotesContent(
  document: DocumentNode,
  lang: Lang,
): string {
  const footnotes = document.footnotes;
  footnotes.children.unshift(helperNote(footnotes, lang));
  const output: Array<string[]> = [];
  traverse(footnotes, visitor, output, { target: `ebook`, lang });
  return output[0]?.join(`\n`) ?? ``;
}

function helperNote(footnotes: AstNode, lang: Lang): AstNode {
  const helper = new Node(n.FOOTNOTE, footnotes);
  const paragraph = new Node(n.PARAGRAPH, helper);
  const text = new Node(n.TEXT, paragraph);

  helper.children = [paragraph];
  paragraph.children = [text];
  text.value = helperNoteText(footnotes.children.length < 4, lang);
  helper.setMetaData(`isFootnoteHelper`, true);

  return helper;
}

function helperNoteText(symbols: boolean, lang: Lang): string {
  if (lang === `en`) {
    const marker = symbols ? `symbol` : `number`;
    return `You made it to the notes area! To get back to where you just were, click the back arrow (\u23CE) at the end of the note, or the ${marker} at the beginning of the note, or use your e-reader’s “back to page...” feature.`;
  }
  // TODO need spanish for "symbol" or "number"
  return `¡Llegaste a la sección de notas! Para volver al lugar donde estabas leyendo, haz clic en la pequeña flecha (\u23CE) al final de la nota, o en el número al principio de la nota, o donde tu aplicación dice  “volver a la página.”`;
}

export function helperNoteSourceMarkup(numTotalFootnotes: number, lang: Lang): string {
  const marker = footnoteMarker(numTotalFootnotes, 0);
  const isSymbol = marker !== `1`;
  const clickTarget = isSymbol ? `symbol` : `note number`;
  const callMarkup = footnoteCallMarkup(1, marker, `notes`);
  const title =
    lang === `en` ? `Help with Footnotes` : `Ayuda con las Notas a Pie de Página`;

  let helpNote = `This e-book contains footnotes. When you see a reference number, click it to access the footnote. Once you're done reading the note, it's easy to get back to exactly where you were just reading—just click the back arrow <span>(\u23CE)</span> after the note, or the ${clickTarget} at the beginning of the note. Here's a sample footnote for you to practice.${callMarkup}`;

  if (lang === `es`) {
    helpNote = `Este libro electrónico contiene notas a pie de página. Cuando veas un número de referencia, haz clic ahí para acceder a la nota al pie. Una vez que hayas terminado de leer la nota, es fácil regresar al lugar exacto en el que estabas leyendo, simplemente haz clic en la pequeña flecha <span>(\u23CE)</span> después de la nota, o el número al principio de la nota. Aquí hay una nota para que practiques${callMarkup}`;
  }

  return `
    <div class="footnote-helper">
      <h3>${title}</h3>
      <p>${helpNote}</p>
    </div>
  `.trim();
}
