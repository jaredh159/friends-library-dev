import { EditableEntity, ErrorMsg } from '../../../types';

export async function mutate<T>(
  type: 'create' | 'update' | 'delete',
  entity: EditableEntity,
  handler: () => Promise<{ data?: T | null | undefined }>,
): Promise<ErrorMsg | null> {
  const verb = type.replace(/e$/, `ing`);
  const entityType = entity.__typename;
  try {
    const { data } = await handler();
    if (!data) {
      return `Unexpected missing data ${verb} ${entityType}`;
    } else {
      return null;
    }
  } catch (err: unknown) {
    return `Error ${verb} ${entityType}: ${err}`;
  }
}

export function prepIds<T extends Record<string, unknown>>(record: T): T {
  for (const key of Object.keys(record)) {
    const value = record[key];
    if (typeof value === `string` && value.match(MATCH_CLIENT_GENERATED_ID)) {
      // @ts-ignore
      record[key] = value.replace(/^_/, ``);
    }
  }
  return record;
}

const MATCH_CLIENT_GENERATED_ID =
  /^_[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i;
