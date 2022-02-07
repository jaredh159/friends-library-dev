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
