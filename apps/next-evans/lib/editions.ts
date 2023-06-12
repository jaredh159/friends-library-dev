import type { Edition } from './types';

export function mostModernEdition(editions: Edition[]): Edition {
  if (editions.includes(`updated`)) return `updated`;
  if (editions.includes(`modernized`)) return `modernized`;
  return `original`;
}
