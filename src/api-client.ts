import fetch from 'cross-fetch';
import env from '@friends-library/env';
import * as db from '@friends-library/db';

export default function getClient(): ReturnType<typeof db.getClient> {
  const token = env.requireVar(`CLI_FLP_API_TOKEN`);
  return db.getClient({ env: `dev`, fetch, token });
}

export const gql = db.gql;
