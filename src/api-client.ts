import fetch from 'cross-fetch';
import * as db from '@friends-library/db';

const client = db.getClient({ env: `infer`, process, fetch });

export default client;

export const gql = db.gql;
