import '@friends-library/env/load';
import env from '@friends-library/env';
import { getClient, gql, ClientConfig, ClientType } from '@friends-library/db';
import { FsDocPrecursor } from './types';
import fetch from 'cross-fetch';
import { Editions } from './graphql/Editions';

export async function getByPattern(
  pattern?: string,
  clientConfig?: ClientConfig,
): Promise<FsDocPrecursor[]> {
  const DOCS_REPOS_ROOT = env.requireVar(`DOCS_REPOS_ROOT`);
  const { data, errors } = await client(clientConfig).query<Editions>({ query: QUERY });
  if (errors) {
    throw new Error(
      `Error querying editions: ${errors.map((e) => e.message).join(`, `)}`,
    );
  }

  // special case: prevent non-match when running cli commands like `fl make` with full paths
  if (pattern && DOCS_REPOS_ROOT.length > 4) {
    pattern = pattern.replace(`${DOCS_REPOS_ROOT}/`, ``);
  }

  return data.editions
    .filter((edition) => !pattern || edition.directoryPath.includes(pattern))
    .map((edition) => editionToFsDpc(edition, DOCS_REPOS_ROOT));
}

function editionToFsDpc(
  edition: Editions['editions'][0],
  docsRoot: string,
): FsDocPrecursor {
  return {
    lang: edition.document.friend.lang === `es` ? `es` : `en`,
    friendSlug: edition.document.friend.slug,
    friendInitials: edition.document.friend.slug
      .split(`-`)
      .map((s) => (s[0] ?? ``).toUpperCase()),
    documentSlug: edition.document.slug,
    fullPath: `${docsRoot}/${edition.directoryPath}`,
    path: edition.directoryPath,
    editionId: edition.id,
    isCompilation: edition.document.friend.isCompilations,
    editionType: edition.type,
    asciidocFiles: [],
    paperbackSplits: edition.paperbackSplits ?? [],
    blurb: edition.document.description,
    config: {},
    customCode: { css: {}, html: {} },
    meta: {
      title: edition.document.title,
      originalTitle: edition.document.originalTitle ?? undefined,
      published: edition.document.published ?? undefined,
      isbn: edition.isbn?.code ?? ``,
      editor: edition.editor ?? undefined,
      author: {
        name: edition.document.friend.name,
        nameSort: edition.document.friend.alphabeticalName,
      },
    },
    revision: {
      timestamp: Date.now(),
      sha: ``,
      url: ``,
    },
  };
}

const QUERY = gql`
  query Editions {
    editions: getEditions {
      id
      type
      editor
      directoryPath
      paperbackSplits
      isbn {
        code
      }
      document {
        title
        originalTitle
        published
        description
        slug
        friend {
          isCompilations
          lang
          slug
          name
          alphabeticalName
        }
      }
    }
  }
`;

function client(config?: ClientConfig): ClientType {
  return getClient({
    ...(config ? config : { env: `infer_node`, process }),
    fetch,
  });
}
