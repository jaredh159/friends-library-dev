import { default as toSpeechText } from './speech/eval-speech';
import { toPdfSrcHtml, toEbookSrcHtml } from './html/eval-html';

export { default as HtmlSrcResult } from './html/result/HtmlSrcResult';
export { default as PdfSrcResult } from './html/result/PdfSrcResult';
export { default as EbookSrcResult } from './html/result/EbookSrcResult';
export { default as ChapterResult } from './html/result/ChapterResult';

// convenience re-export for libs that only want to evaluate, but also handle ParserError's
export { ParserError } from '@friends-library/parser';

const evaluate = {
  toPdfSrcHtml,
  toEbookSrcHtml,
  toSpeechText,
};

export { evaluate };
