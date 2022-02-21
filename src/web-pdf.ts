import * as css from './css';

export default function webPdfCss(config: { customCss?: string }): string {
  return [
    css.common,
    css.signedSections,
    css.tables,
    css.notMobi7,
    css.pdfBase,
    css.pdfTypography,
    css.pdfHalfTitle,
    css.pdfOriginalTitle,
    css.pdfCopyright,
    css.pdfToc,
    css.pdfChapterHeading,
    css.pdfWeb,
    css.pdfIntermediateTitle,
    ...(config.customCss ? [config.customCss] : []),
  ].join(`\n\n`);
}
