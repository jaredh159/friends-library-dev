import FsDocPrecursor from '../FsDocPrecursor';
import meta from './meta';
import revision from './revision';
import config from './config';
import customCode from './custom-code';
import asciidoc, { HydrateAsciidocConfig } from './asciidoc';

export default function all(
  dpcs: FsDocPrecursor[],
  adocConfig: HydrateAsciidocConfig = {},
): void {
  dpcs.forEach(meta);
  dpcs.forEach(revision);
  dpcs.forEach(config);
  dpcs.forEach(customCode);
  dpcs.forEach((dpc) => asciidoc(dpc, adocConfig));
}
