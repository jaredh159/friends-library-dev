import { EditableEntity, ErrorMsg } from '../../../types';

export async function createEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`CREATE ENTITY:`, entity);
  await new Promise((res) => setTimeout(res, 2000));
  return null;
}

export async function deleteEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`DELETE ENTITY:`, entity);
  await new Promise((res) => setTimeout(res, 2000));
  return null;
}

export async function updateEntity(
  current: EditableEntity,
  previous: EditableEntity,
): Promise<ErrorMsg | null> {
  console.log(`UPDATE:`, { current, previous });
  await new Promise((res) => setTimeout(res, 2000));
  return null;
}
