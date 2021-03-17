import { Html } from '@friends-library/types';
import HtmlSrcResult from './HtmlSrcResult';

export default class PdfSrcResult extends HtmlSrcResult {
  public mergedChapterHtml(startIndex = 0, endIndex = Infinity): Html {
    return this.chapters
      .slice(startIndex, endIndex)
      .map(({ content: html }) => html)
      .join(`\n\n`);
  }
}
