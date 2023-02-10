import { execSync } from 'child_process';
import { paperbackCover } from '@friends-library/doc-manifests';
import { pdf, deleteNamespaceDir } from '@friends-library/doc-artifacts';
import { hydrate, query as dpcQuery } from '@friends-library/dpc-fs';
import client, { gql } from '../../api-client';
import { GetCoverData, GetCoverDataVariables } from '../../graphql/GetCoverData';
import { PrintSize } from '@friends-library/types';

interface CoverOptions {
  pattern: string;
}

export default async function handler(argv: CoverOptions): Promise<void> {
  deleteNamespaceDir(`fl-cover`);
  const dpcs = await dpcQuery.getByPattern(argv.pattern);

  for (const dpc of dpcs) {
    hydrate.customCode(dpc);

    const { data } = await client.query<GetCoverData, GetCoverDataVariables>({
      query: QUERY_VOLUMES,
      variables: { id: dpc.editionId },
    });

    const impression = data.edition.impression;
    if (!impression) {
      throw new Error(`No EditionImpression found for ${dpc.path}`);
    }

    const manifests = await paperbackCover(dpc, {
      printSize: impression.paperbackSize.replace(/--condensed$/, ``) as PrintSize,
      volumes: impression.paperbackVolumes,
    });

    for (let i = 0; i < manifests.length; i++) {
      const manifest = manifests[i]!;
      const filename = `cover-${dpc.editionId}-${data.edition.type}-${i}`;
      const pdfPath = await pdf(manifest, filename, { namespace: `fl-cover` });
      execSync(`open ${pdfPath}`);
    }
  }
}

const QUERY_VOLUMES = gql`
  query GetCoverData($id: UUID!) {
    edition: getEdition(id: $id) {
      type
      impression {
        paperbackVolumes
        paperbackSize
      }
    }
  }
`;
