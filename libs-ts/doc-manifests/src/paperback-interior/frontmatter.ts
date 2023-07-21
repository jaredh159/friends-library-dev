import { toRoman } from 'roman-numerals';
import type { DocPrecursor } from '@friends-library/types';
import type { PdfSrcResult, ChapterResult } from '@friends-library/evaluator';
import {
  originalTitle as commonOriginalTitle,
  copyright as commonCopyright,
  halfTitle as commonHalfTitle,
} from '../frontmatter';
import { rangeFromVolIdx } from '../faux-volumes';

export default function frontmatter(
  dpc: DocPrecursor,
  src: PdfSrcResult,
  volIdx?: number,
): string {
  const isFirstOrOnlyVolume = typeof volIdx !== `number` || volIdx === 0;
  return `
    ${halfTitle(dpc, volIdx)}
    ${isFirstOrOnlyVolume ? originalTitle(dpc) : ``}
    ${copyright(dpc)}
    ${isFirstOrOnlyVolume ? src.epigraphHtml : ``}
    ${toc(src, dpc, volIdx)}
  `;
}

function toc(src: PdfSrcResult, dpc: DocPrecursor, volIdx?: number): string {
  if (src.numChapters <= 3) {
    return ``;
  }
  const toEntry = shouldUseMultiColLayout(src.chapters) ? multiColTocEntry : tocEntry;
  return `
    <div class="toc own-page">
      <h1>${dpc.lang === `en` ? `Contents` : `Índice`}</h1>
      ${src.chapters
        .slice(...rangeFromVolIdx(dpc.paperbackSplits, volIdx))
        .map(toEntry)
        .join(`\n`)}
    </div>
  `;
}

export function shouldUseMultiColLayout(chapters: ChapterResult[]): boolean {
  // keep only chapters with headings like `"Chapter IV. The Lambs War"`
  // which, when they predominate, make the multi-col layout desirable
  const numberedAndNamedChapters = chapters.filter(
    (c) => !c.isIntermediateTitle && c.isSequenced && c.hasNonSequenceTitle,
  );
  const nonItermediateChapters = chapters.filter((c) => !c.isIntermediateTitle);
  return numberedAndNamedChapters.length / nonItermediateChapters.length > 0.45;
}

function multiColTocEntry(chapter: ChapterResult): string {
  if (chapter.isIntermediateTitle) {
    return tocEntry(chapter);
  }

  const [chapterCol, mainCol] = multiColTocParts(chapter);
  return `
    <p class="multicol-toc-entry">
      <a href="#${chapter.id}">
        <span class="multicol-toc-chapter">
          ${chapterCol}
        </span>
        <span class="multicol-toc-main">
          ${mainCol}
        </span>
      </a>
    </p>
    `.trim();
}

export function multiColTocParts(
  chapter: ChapterResult,
): [chapter: string, main: string] {
  // if we have a sequence (chapter) number, and a non-sequence title
  // we split the chapter number left, and non-sequence title right
  // otherwise, everything goes on right
  const shouldSplit =
    typeof chapter.sequenceNumber === `number` && chapter.hasNonSequenceTitle;

  let main = chapter.shortHeading;
  if (chapter.nonSequenceTitle && chapter.nonSequenceTitle.length < main.length) {
    main = chapter.nonSequenceTitle;
  }

  if (shouldSplit) {
    const withoutLeadingSequence = main.replace(
      /^(Chapter|Section|Capítulo|Sección) [IVXL]+ (&#8212;|--|—) /,
      ``,
    );
    if (withoutLeadingSequence.trim().length > 0) {
      main = withoutLeadingSequence;
    }
  }

  return [shouldSplit ? toRoman(chapter.sequenceNumber ?? 1) : ``, main];
}

function tocEntry(chapter: ChapterResult): string {
  return `
    <p${chapter.isIntermediateTitle ? ` class="toc-intermediate-title"` : ``}>
      <a href="#${chapter.id}">
        <span>${chapter.shortHeading}</span>
      </a>
    </p>`;
}

function copyright(dpc: DocPrecursor): string {
  return commonCopyright(dpc)
    .replace(`copyright-page`, `copyright-page own-page`)
    .replace(`Ebook created`, `Created`)
    .replace(/([^@])friendslibrary\.com/g, `$1www.friendslibrary.com`);
}

function halfTitle(dpc: DocPrecursor, volIdx?: number): string {
  return `
    <div class="half-title-page own-page">
      <div>
        ${commonHalfTitle(dpc, volIdx)}
      </div>
    </div>
  `;
}

function originalTitle(dpc: DocPrecursor): string {
  if (!dpc.meta.originalTitle) {
    return ``;
  }

  return `
    <div class="blank-page own-page"></div>
    ${commonOriginalTitle(dpc)}
  `;
}
