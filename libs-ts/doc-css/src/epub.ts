import * as css from './css';

export function epub(config: { customCss?: string } = {}): string {
  return [
    css.common,
    css.signedSections,
    css.tables,
    css.ebookCommon,
    css.notMobi7,
    css.ebookEpub,
    css.ebookIntermediateTitle,
    ...(config.customCss ? [config.customCss] : []),
  ].join(`\n\n`);
}

export function mobi(config: { customCss?: string } = {}): string {
  let mobiCss = [
    css.common,
    css.signedSections,
    css.tables,
    css.ebookCommon,
    css.ebookIntermediateTitle,
  ].join(`\n\n`);

  mobiCss += `\n@media amzn-mobi {\n${css.ebookMobi}\n}`;
  mobiCss += `\n@media amzn-kf8 {\n${css.notMobi7}\n${css.ebookKf8}\n}`;
  mobiCss += config.customCss ? `\n\n${config.customCss}` : ``;
  return mobiCss;
}
