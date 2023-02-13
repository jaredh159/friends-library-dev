import type { FsDocPrecursor } from '@friends-library/dpc-fs';
import type { UpdateEditionImpressionInput } from '../../graphql/globalTypes';
import type { PublishEdition } from '../../graphql/PublishEdition';
import type { UpdateEditionImpression } from '../../graphql/UpdateEditionImpression';

export type Edition = PublishEdition['edition'];
export type CloudFiles = UpdateEditionImpression['impression']['files'];

export interface PendingUploads {
  paperback: {
    cover: string[];
    interior: string[];
  };
  ebook: {
    pdf: string;
    epub: string;
    mobi: string;
    speech: string;
    app: string;
    appCss?: string;
  };
  images: {
    square: Array<{ localPath: string; cloudPath: string }>;
    threeD: Array<{ localPath: string; cloudPath: string }>;
  };
}

export function emptyPendingUploads(): PendingUploads {
  return {
    paperback: { cover: [], interior: [] },
    ebook: { pdf: ``, epub: ``, mobi: ``, speech: ``, app: `` },
    images: { square: [], threeD: [] },
  };
}

export interface PublishData {
  edition: Edition;
  dpc: FsDocPrecursor;
  uploads: PendingUploads;
  artifactOptions: { namespace: string; srcPath: string };
  impression: {
    current: UpdateEditionImpressionInput;
    previous: UpdateEditionImpressionInput | null;
  };
}
