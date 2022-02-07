import { ApolloClient, InMemoryCache, createHttpLink, from, gql } from '@apollo/client';
import { setContext } from '@apollo/client/link/context';

const httpLink = createHttpLink({
  uri: import.meta.env.SNOWPACK_PUBLIC_FLP_GRAPHQL_API_ENDPOINT,
});

const authLink = setContext((_, { headers }) => {
  const token = localStorage.getItem(`token`);
  return {
    headers: {
      ...headers,
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
  };
});

const client = new ApolloClient({
  link: from([authLink, httpLink]),
  cache: new InMemoryCache(),
});

export default client;

declare global {
  interface ImportMeta {
    env: {
      SNOWPACK_PUBLIC_FLP_GRAPHQL_API_ENDPOINT: string;
    };
  }
}

export const SELECTABLE_DOCUMENTS_FIELDS = gql`
  fragment SelectableDocumentsFields on Document {
    id
    title
    friend {
      lang
      alphabeticalName
    }
  }
`;

export const EDIT_EDITION_FIELDS = gql`
  fragment EditEditionFields on Edition {
    id
    type
    paperbackSplits
    paperbackOverrideSize
    isbn {
      code
    }
    isDraft
  }
`;

export const EDIT_DOCUMENT_FIELDS = gql`
  ${EDIT_EDITION_FIELDS}
  fragment EditDocumentFields on Document {
    id
    altLanguageId
    title
    slug
    filename
    published
    originalTitle
    incomplete
    description
    partialDescription
    featuredDescription
    friend {
      id
      name
      lang
    }
    editions {
      ...EditEditionFields
    }
    tags {
      id
      type
    }
    relatedDocuments {
      id
      description
      documentId
    }
  }
`;
