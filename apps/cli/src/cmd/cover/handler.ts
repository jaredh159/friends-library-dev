import { execSync } from 'child_process';
import { paperbackCover } from '@friends-library/doc-manifests';
import { pdf, deleteNamespaceDir } from '@friends-library/doc-artifacts';
import { hydrate, query as dpcQuery } from '@friends-library/dpc-fs';
import api from '../../api-client';

interface CoverOptions {
  pattern: string;
}

export default async function handler(argv: CoverOptions): Promise<void> {
  deleteNamespaceDir(`fl-cover`);
  const dpcs = await dpcQuery.getByPattern(argv.pattern);

  for (const dpc of dpcs) {
    hydrate.customCode(dpc);
    const edition = (await api.getEdition(dpc.editionId)).unwrap();
    const impression = edition.impression;
    if (!impression) {
      throw new Error(`No EditionImpression found for ${dpc.path}`);
    }

    const manifests = await paperbackCover(dpc, {
      printSize: impression.paperbackSize,
      volumes: impression.paperbackVolumes,
    });

    for (let i = 0; i < manifests.length; i++) {
      const manifest = manifests[i]!;
      const filename = `cover-${dpc.editionId}-${edition.type}-${i}`;
      const pdfPath = await pdf(manifest, filename, { namespace: `fl-cover` });
      execSync(`open ${pdfPath}`);
    }
  }
}
