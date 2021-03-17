import { Html } from '@friends-library/types';
import HtmlSrcResult from './HtmlSrcResult';
import evalEbookFootnotesContent, { helperNoteSourceMarkup } from '../ebook-footnotes';

export default class EbookSrcResult extends HtmlSrcResult {
  public get notesContentHtml(): Html {
    return evalEbookFootnotesContent(this.document, this.lang);
  }

  public get footnoteHelperSourceHtml(): Html {
    return helperNoteSourceMarkup(this.numFootnotes, this.lang);
  }
}
