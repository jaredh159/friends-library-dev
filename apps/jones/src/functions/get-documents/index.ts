import { gql } from '@friends-library/db';
import type { Handler } from '@netlify/functions';
import type { GetDocuments } from '../../graphql/GetDocuments';
import { client } from './client';

const handler: Handler = async () => {
  const { data, errors } = await client().query<GetDocuments>({ query: QUERY_DOCUMENT });

  if (errors) {
    return {
      statusCode: 500,
      body: JSON.stringify({ errors }),
    };
  }

  const map = data.documents.reduce<Record<string, string>>((map, document) => {
    map[document.path] = document.title;
    return map;
  }, {});

  return {
    statusCode: 200,
    body: JSON.stringify(map),
  };
};

export { handler };

const QUERY_DOCUMENT = gql`
  query GetDocuments {
    documents: getDocuments {
      title: trimmedUtf8ShortTitle
      path: directoryPath
    }
  }
`;
