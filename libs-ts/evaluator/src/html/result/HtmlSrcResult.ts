import { Lang } from '@friends-library/types';
import { DocumentNode } from '@friends-library/parser';
import ChapterResult from './ChapterResult';
import evalEpigraphs from '../eval-epigraphs';

export default abstract class HtmlSrcResult {
  private _chapters: ChapterResult[] | null = null;

  public constructor(
    protected output: Array<string[]>,
    protected document: DocumentNode,
    protected lang: Lang,
  ) {}

  public get numFootnotes(): number {
    return this.document.footnotes.children.length;
  }

  public get hasFootnotes(): boolean {
    return this.numFootnotes > 0;
  }

  public get numChapters(): number {
    return this.chapters.length;
  }

  public get hasEpigraphs(): boolean {
    return this.document.epigraphs.children.length > 0;
  }

  public get epigraphHtml(): string {
    return evalEpigraphs(this.document, this.lang);
  }

  public get chapters(): ChapterResult[] {
    if (this._chapters) {
      return this._chapters;
    }

    this._chapters = this.document.chapters.map((chapter, idx) => {
      const chapterOutput = this.output[idx];
      if (chapterOutput === undefined) {
        throw new Error(`Unexpected missing chapter output for index=${idx}`);
      }

      let sequenceNumber: number | undefined;
      try {
        sequenceNumber = chapter.expectNumberMetaData(`sequenceNumber`);
      } catch {
        // ¯\_(ツ)_/¯
      }

      let nonSequenceTitle: string | undefined;
      try {
        nonSequenceTitle = chapter.expectStringMetaData(`nonSequenceTitle`);
      } catch {
        // ¯\_(ツ)_/¯
      }

      return new ChapterResult(
        idx,
        chapterOutput.join(`\n`),
        chapter.expectStringMetaData(`shortChapterHeading`),
        chapter.hasClass(`intermediate-title`),
        sequenceNumber,
        nonSequenceTitle,
        chapter.expectStringMetaData(`id`),
      );
    });

    return this._chapters;
  }
}
