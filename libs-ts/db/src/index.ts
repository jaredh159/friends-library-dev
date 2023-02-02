export { gql } from '@apollo/client';
export { getClient } from './Client';
export type { ClientConfig, ClientType } from './Client';

export function writable<T>(apolloReadOnlyObject: T): T {
  return JSON.parse(JSON.stringify(apolloReadOnlyObject));
}
