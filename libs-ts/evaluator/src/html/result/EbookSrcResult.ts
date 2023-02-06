import HtmlSrcResult from './HtmlSrcResult';
import evalEbookFootnotesContent, { helperNoteSourceMarkup } from '../ebook-footnotes';

export default class EbookSrcResult extends HtmlSrcResult {
  public get notesContentHtml(): string {
    return evalEbookFootnotesContent(this.document, this.lang);
  }

  public get footnoteHelperSourceHtml(): string {
    return helperNoteSourceMarkup(this.numFootnotes, this.lang);
  }
}
