import * as friend from './crud.friend';
import * as document from './crud.document';
import * as residence from './crud.residence';
import * as duration from './crud.duration';
import * as quote from './crud.quote';
import * as tag from './crud.tag';
import { EditableEntity, ErrorMsg } from '../../../types';

export async function createEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`CREATE:`, entity);
  switch (entity.__typename) {
    case `Friend`:
      return friend.create(entity);
    case `FriendQuote`:
      return quote.create(entity);
    case `FriendResidence`:
      return residence.create(entity);
    case `FriendResidenceDuration`:
      return duration.create(entity);
    case `Document`:
      return document.create(entity);
    case `DocumentTag`:
      return tag.create(entity);
    default:
      throw new Error(`Unsupported entity type for create: ${entity.__typename}`);
  }
}

export async function deleteEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`DELETE:`, entity);
  let err: ErrorMsg | null = null;
  switch (entity.__typename) {
    case `FriendQuote`:
      err = await quote.delete(entity);
      break;
    case `FriendResidence`:
      err = await residence.delete(entity);
      break;
    case `FriendResidenceDuration`:
      err = await duration.delete(entity);
      break;
    case `Document`:
      err = await document.delete(entity);
      break;
    case `DocumentTag`:
      err = await tag.delete(entity);
      break;
    default:
      throw new Error(`Unsupported entity type for delete: ${entity.__typename}`);
  }

  // foreign key cascades often mean that our entities get deleted
  // when the parent is deleted, so treat a DELETE -> 404 as success
  if (err && err.includes(`notFound`)) {
    return null;
  }

  return err;
}

export async function updateEntity(entity: EditableEntity): Promise<ErrorMsg | null> {
  console.log(`UPDATE:`, entity);
  switch (entity.__typename) {
    case `Friend`:
      return friend.update(entity);
    case `FriendQuote`:
      return quote.update(entity);
    case `FriendResidence`:
      return residence.update(entity);
    case `FriendResidenceDuration`:
      return duration.update(entity);
    case `Document`:
      return document.update(entity);
    case `DocumentTag`:
      return tag.update(entity);
    default:
      throw new Error(`Unsupported entity type for update: ${entity.__typename}`);
  }
}
