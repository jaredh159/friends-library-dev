import { AppEditionResourceV1 as Edition } from '@friends-library/api';
import gql from '../lib/gql';

export async function validateToken(token: string): Promise<string | null> {
  const ENDPOINT = import.meta.env.SNOWPACK_PUBLIC_FLP_GRAPHQL_API_ENDPOINT;
  await new Promise((res) => setTimeout(res, 3000));

  try {
    const res = await fetch(ENDPOINT, {
      method: `POST`,
      headers: { 'Content-Type': `application/json` },
      body: JSON.stringify({
        query: QUERY_TOKEN,
        variables: { value: token },
      }),
    });

    const json = await res.json();
    if (json.errors) {
      const msg = String(json.errors[0].message);
      if (msg.includes(`404`)) {
        return `Token not found.`;
      }
      return msg;
    }

    if (json.data) {
      for (const scope of json.data.token.scopes) {
        if (scope.name === `mutateOrders`) {
          return null;
        }
      }
      return `Token does not have required permission.`;
    }
  } catch (error: unknown) {
    return String(error);
  }

  return `Unknown error`;
}

export async function getEditions(): Promise<Array<Edition & { searchString: string }>> {
  const ENDPOINT = import.meta.env.SNOWPACK_PUBLIC_FLP_REST_API_ENDPOINT;
  const en = fetch(`${ENDPOINT}/app-editions/v1/en`).then((res) => res.json());
  const es = fetch(`${ENDPOINT}/app-editions/v1/es`).then((res) => res.json());
  return await Promise.all([en, es]).then(([english, spanish]) => {
    return [...english, ...spanish].map((edition: Edition) => {
      const searchString = [edition.document.title, edition.friend.name, edition.type]
        .join(` `)
        .toLowerCase();
      return {
        ...edition,
        searchString,
      };
    });
  });
}
const QUERY_TOKEN = gql`
  query GetTokenByValue($value: String!) {
    token: getTokenByValue(value: $value) {
      scopes {
        name: scope
      }
    }
  }
`;

declare global {
  interface ImportMeta {
    env: {
      SNOWPACK_PUBLIC_FLP_REST_API_ENDPOINT: string;
      SNOWPACK_PUBLIC_FLP_GRAPHQL_API_ENDPOINT: string;
    };
  }
}
