import fetch from 'cross-fetch';
import * as db from '@friends-library/db';

const client = db.getClient({ env: `infer_node`, process, fetch });

export default client;

export const gql = db.gql;
export const writable = db.writable;
