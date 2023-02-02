import isEqual from 'lodash.isequal';
import omit from 'lodash.omit';
import type {
  EditableDocument,
  EditableEntity,
  EditableFriend,
  EditableFriendResidence,
  Progress,
  WorkQueue,
  EntityOperation,
  CreateOperation,
  UpdateOperation,
  DeleteOperation,
  Operation,
  EditableEdition,
  EditableAudio,
  EditableToken,
} from '../../../types';
import { createEntity, deleteEntity, updateEntity } from './crud.entities';

export async function save<T extends EditableEntity>(
  progress: Progress,
  current?: T,
  previous?: T,
): Promise<void> {
  return perform(getWork(current, previous), progress);
}

function getWork<T extends EditableEntity>(
  current: T | undefined,
  previous: T | undefined,
): WorkQueue {
  const operation = getOperation(current, previous);
  switch (operation.type) {
    case `create`:
      return getCreateWork(operation);
    case `update`:
      return getUpdateWork(operation);
    case `delete`:
      return getDeleteWork(operation);
    case `noop`:
      return [];
  }
}

function getCreateWork<T extends EditableEntity>(
  operation: CreateOperation<T>,
): WorkQueue {
  let queue: WorkQueue = [{ operation, status: `not started` }];
  for (const [, extract] of subcollections(operation.entity)) {
    queue = queue.concat(collectionQueue(operation, extract));
  }
  for (const [, extract] of optionalChildren(operation.entity)) {
    const child = extract(operation.entity);
    if (child) {
      queue = queue.concat(getCreateWork({ type: `create`, entity: child }));
    }
  }
  return queue;
}

function getUpdateWork<T extends EditableEntity>(
  operation: UpdateOperation<T>,
): WorkQueue {
  let queue: WorkQueue = [];
  const omitKeys = omittable(operation.current);
  if (!isEqual(omit(operation.current, omitKeys), omit(operation.previous, omitKeys))) {
    queue.push({ operation, status: `not started` });
  }
  for (const [, extract] of subcollections(operation.current)) {
    queue = queue.concat(collectionQueue(operation, extract));
  }
  for (const [, extract] of optionalChildren(operation.current)) {
    const current = extract(operation.current);
    const prev = extract(operation.previous);
    queue = queue.concat(getWork(current ?? undefined, prev ?? undefined));
  }
  return queue;
}

function getDeleteWork<T extends EditableEntity>(
  operation: DeleteOperation<T>,
): WorkQueue {
  let queue: WorkQueue = [{ operation, status: `not started` }];
  for (const [, extract] of subcollections(operation.entity)) {
    queue = queue.concat(collectionQueue(operation, extract));
  }
  for (const [, extract] of optionalChildren(operation.entity)) {
    const child = extract(operation.entity);
    if (child) {
      queue = queue.concat(getDeleteWork({ type: `delete`, entity: child }));
    }
  }
  return queue;
}

function collectionQueue<T extends EditableEntity>(
  operation: Operation<T>,
  extract: (root: T) => EditableEntity[] | undefined,
): WorkQueue {
  let queue: WorkQueue = [];

  switch (operation.type) {
    case `create`: {
      const collection = extract(operation.entity);
      for (const item of collection ?? []) {
        queue = queue.concat(getCreateWork({ type: `create`, entity: item }));
      }
      break;
    }
    case `update`: {
      const currentCollection = extract(operation.current);
      const previousCollection = extract(operation.previous);
      for (const newItem of currentCollection ?? []) {
        const prevItem = findIn(newItem, previousCollection);
        if (prevItem && !isEqual(newItem, prevItem)) {
          queue = queue.concat(
            getUpdateWork({ type: `update`, current: newItem, previous: prevItem }),
          );
        } else if (!prevItem) {
          queue = queue.concat(getCreateWork({ type: `create`, entity: newItem }));
        }
      }
      for (const prevItem of previousCollection ?? []) {
        if (!findIn(prevItem, currentCollection)) {
          queue = queue.concat(getDeleteWork({ type: `delete`, entity: prevItem }));
        }
      }
      break;
    }
    case `delete`: {
      const collection = extract(operation.entity);
      for (const item of collection ?? []) {
        queue = queue.concat(getDeleteWork({ type: `delete`, entity: item }));
      }
      break;
    }
  }

  return queue;
}

function getOperation<T extends EditableEntity>(
  current?: T,
  previous?: T,
): EntityOperation {
  if (previous?.id.startsWith(`_`)) {
    previous = undefined;
  }
  if (current && !previous) {
    return { type: `create`, entity: current };
  } else if (current && previous) {
    return { type: `update`, previous, current };
  } else if (!current && previous) {
    return { type: `delete`, entity: previous };
  } else {
    return { type: `noop` };
  }
}

function omittable(entity: EditableEntity): string[] {
  return subcollections(entity)
    .map(([key]) => key)
    .concat(optionalChildren(entity).map(([key]) => key));
}

function optionalChildren(
  entity: EditableEntity,
): Array<[key: string, extractor: (root: any) => EditableEntity | null]> {
  switch (entity.__typename) {
    case `Edition`:
      return [[`audio`, (edition) => (edition as EditableEdition).audio]];
    case `Friend`:
    case `FriendResidence`:
    case `Document`:
    case `Audio`:
    case `AudioPart`:
    case `FriendQuote`:
    case `FriendResidenceDuration`:
    case `RelatedDocument`:
    case `DocumentTag`:
    case `Token`:
    case `TokenScope`:
      return [];
  }
}

function subcollections(
  entity: EditableEntity,
): Array<[key: string, extractor: (root: any) => EditableEntity[] | undefined]> {
  switch (entity.__typename) {
    case `Friend`:
      return [
        [`quotes`, (friend) => (friend as EditableFriend).quotes],
        [`documents`, (friend) => (friend as EditableFriend).documents],
        [`residences`, (friend) => (friend as EditableFriend).residences],
      ];
    case `FriendResidence`:
      return [
        [`durations`, (residence) => (residence as EditableFriendResidence).durations],
      ];
    case `Document`:
      return [
        [`editions`, (doc) => (doc as EditableDocument).editions],
        [`relatedDocuments`, (doc) => (doc as EditableDocument).relatedDocuments],
        [`tags`, (doc) => (doc as EditableDocument).tags],
      ];
    case `Audio`:
      return [[`parts`, (audio) => (audio as EditableAudio).parts]];
    case `Token`:
      return [[`scopes`, (token) => (token as EditableToken).scopes]];
    case `FriendQuote`:
    case `FriendResidenceDuration`:
    case `RelatedDocument`:
    case `DocumentTag`:
    case `Edition`:
    case `AudioPart`:
    case `TokenScope`:
      return [];
  }
}

export async function perform(queue: WorkQueue, progress: Progress): Promise<void> {
  const updateProgress: (error?: string | null) => unknown = (error) =>
    progress(
      queue.map((item) => ({ ...item })),
      error ?? undefined,
    );

  const completed: WorkQueue = [];

  async function rollback(): Promise<void> {
    for (const completedItem of completed.reverse()) {
      try {
        let err: string | null = null;
        completedItem.status = `rolling back`;
        updateProgress();
        switch (completedItem.operation.type) {
          case `create`:
            err = await deleteEntity(completedItem.operation.entity);
            break;
          case `update`:
            err = await updateEntity(completedItem.operation.previous);
            break;
          case `delete`:
            err = await createEntity(completedItem.operation.entity);
            break;
        }
        completedItem.status = err ? `rollback failed` : `rollback succeeded`;
        updateProgress(err);
      } catch (err: unknown) {
        completedItem.status = `rollback failed`;
        updateProgress(`Error rolling back: ${err}`);
      }
    }
  }

  updateProgress();

  for (const item of queue) {
    item.status = `in flight`;
    updateProgress();
    try {
      let err: string | null = null;
      switch (item.operation.type) {
        case `create`:
          err = await createEntity(item.operation.entity);
          break;
        case `update`:
          err = await updateEntity(item.operation.current);
          break;
        case `delete`:
          err = await deleteEntity(item.operation.entity);
          break;
      }
      item.status = err ? `failed` : `succeeded`;
      updateProgress(err);
      if (err) {
        return rollback();
      } else {
        completed.push(item);
      }
    } catch (err: unknown) {
      item.status = `failed`;
      updateProgress(`Error saving item: ${err}`);
      return rollback();
    }
  }
}

function findIn<T extends EditableEntity>(entity: T, collection?: T[]): T | undefined {
  return (collection ?? []).find(same(entity));
}

function same<T extends EditableEntity>(entity: T): (item: T) => boolean {
  return (item) => item.id === entity.id && item.__typename === entity.__typename;
}
