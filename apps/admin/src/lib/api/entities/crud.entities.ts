import type { ErrorMsg } from '../../../types';
import api, { type T } from '../../../api-client';
import { removeClientGeneratedIdPrefix } from './helpers';

export async function createEntity(entity: T.UpsertEntity): Promise<ErrorMsg | null> {
  const result = await api.createEntity(removeEntityIdPrefix(entity));
  return result.reduce({
    success: () => null,
    error: (err) => err.detail ?? `id: ${err.id}, type: ${err.type}}`,
  });
}

export async function deleteEntity(upsert: T.UpsertEntity): Promise<ErrorMsg | null> {
  const result = await api.deleteEntity({
    type: upsert.case,
    id: removeClientGeneratedIdPrefix(upsert.entity.id),
  });
  return result.reduce({
    success: () => null,
    error: (err) => err.detail ?? `id: ${err.id}, type: ${err.type}}`,
  });
}

export async function updateEntity(entity: T.UpsertEntity): Promise<ErrorMsg | null> {
  const result = await api.updateEntity(removeEntityIdPrefix(entity));
  return result.reduce({
    success: () => null,
    error: (err) => err.detail ?? `id: ${err.id}, type: ${err.type}}`,
  });
}

function removeEntityIdPrefix(upsert: T.UpsertEntity): T.UpsertEntity {
  return {
    case: upsert.case,
    entity: { ...upsert.entity, id: removeClientGeneratedIdPrefix(upsert.entity.id) },
  } as T.UpsertEntity;
}
