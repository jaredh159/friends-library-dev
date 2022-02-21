import '@friends-library/env/load';
import env from '@friends-library/env';
import { getClient, gql, ClientOptions, ClientType } from '@friends-library/db';
import { FsDocPrecursor } from './types';
import fetch from 'cross-fetch';
import { Editions } from './graphql/Editions';

export async function getByPattern(
  pattern?: string,
  dbOptions?: ClientOptions,
): Promise<FsDocPrecursor[]> {
  const { data, errors } = await client(dbOptions).query<Editions>({ query: QUERY });
  if (errors) {
    throw new Error(
      `Error querying editions: ${errors.map((e) => e.message).join(`, `)}`,
    );
  }

  const DOCS_REPOS_ROOT = env.requireVar(`DOCS_REPOS_ROOT`);
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

function client(options?: ClientOptions): ClientType {
  if (!options) {
    const token = env.requireVar(`DPCFS_FLP_API_TOKEN`);
    return getClient({ mode: `production`, fetch, token });
  }
  return getClient({ ...options, fetch });
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
