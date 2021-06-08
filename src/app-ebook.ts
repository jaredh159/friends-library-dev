import { Css } from '@friends-library/types';
import * as css from './css';

export default function appEbookCss(): Css {
  return [
    css.common,
    css.signedSections,
    css.tables,
    css.notMobi7,
    css.pdfBase,
    css.pdfTypography,
    css.pdfChapterHeading,
    css.pdfPaperbackInterior,
    css.pdfIntermediateTitle,
    css.appEbook,
  ].join(`\n\n`);
}
