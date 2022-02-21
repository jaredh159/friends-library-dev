import { FsDocPrecursor } from '../types';
import revision from './revision';
import config from './config';
import customCode from './custom-code';
import asciidoc, { HydrateAsciidocConfig } from './asciidoc';

export default function all(
  dpcs: FsDocPrecursor[],
  adocConfig: HydrateAsciidocConfig = {},
): void {
  dpcs.forEach(revision);
  dpcs.forEach(config);
  dpcs.forEach(customCode);
  dpcs.forEach((dpc) => asciidoc(dpc, adocConfig));
}
