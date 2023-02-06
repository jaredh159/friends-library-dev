import evalEbookFootnotesContent, { helperNoteSourceMarkup } from '../ebook-footnotes';
import HtmlSrcResult from './HtmlSrcResult';

export default class EbookSrcResult extends HtmlSrcResult {
  public get notesContentHtml(): string {
    return evalEbookFootnotesContent(this.document, this.lang);
  }

  public get footnoteHelperSourceHtml(): string {
    return helperNoteSourceMarkup(this.numFootnotes, this.lang);
  }
}
