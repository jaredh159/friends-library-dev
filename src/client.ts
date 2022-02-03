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

export const EDIT_DOCUMENT_FIELDS = gql`
  fragment EditDocumentFields on Document {
    id
    friend {
      name
      lang
    }
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
  }
`;
