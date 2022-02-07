import * as friend from './crud.friend';
import * as document from './crud.document';
import { EditableEntity, ErrorMsg } from '../../../types';

export async function createEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`CREATE:`, entity);
  switch (entity.__typename) {
    case `Friend`:
      return friend.create(entity);
    case `Document`:
      return document.create(entity);
  }
  await new Promise((res) => setTimeout(res, 2000));
  return null;
}

export async function deleteEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`DELETE:`, entity);
  await new Promise((res) => setTimeout(res, 2000));
  return null;
}

export async function updateEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`UPDATE:`, entity);
  switch (entity.__typename) {
    case `Friend`:
      return friend.update(entity);
    case `Document`:
      return document.update(entity);
  }
  await new Promise((res) => setTimeout(res, 2000));
  return null;
}
