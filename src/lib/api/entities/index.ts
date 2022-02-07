import isEqual from 'lodash.isequal';
import omit from 'lodash.omit';
import {
  EditableDocument,
  EditableEntity,
  EditableFriend,
  EditableFriendResidence,
  Progress,
  WorkQueue,
} from '../../../types';
import { createEntity, deleteEntity, updateEntity } from './crud.entities';

type Operation<T extends EditableEntity> =
  | { type: `create`; entity: T }
  | { type: `update`; previous: T; current: T }
  | { type: `delete`; entity: T };

export async function save<T extends EditableEntity>(
  progress: Progress,
  current?: T,
  previous?: T,
): Promise<void> {
  let work: WorkQueue = [];
  const operation = getOperation(current, previous);
  switch (operation.type) {
    case `create`:
      work = getCreateWork(operation.entity);
      break;
    case `update`:
      work = getUpdateWork(operation.current, operation.previous);
      break;
    case `delete`:
      work = getDeleteWork(operation.entity);
      break;
  }
  await perform(work, progress);
}

function getCreateWork(entity: EditableEntity): WorkQueue {
  let queue: WorkQueue = [];
  queue.push({
    step: { description: `Create ${entity.__typename}`, status: `not started` },
    exec: () => createEntity(entity),
    rollback: () => deleteEntity(entity),
  });

  for (const [, extract] of subcollections(entity)) {
    queue = queue.concat(collectionQueue({ type: `create`, entity }, extract));
  }
  return queue;
}

function getUpdateWork<T extends EditableEntity>(current: T, previous: T): WorkQueue {
  let queue: WorkQueue = [];
  const children = subcollections(current).map(([key]) => key);
  if (!isEqual(omit(current, children), omit(previous, children))) {
    queue.push({
      step: { description: `Update ${current.__typename}`, status: `not started` },
      exec: () => updateEntity(current, previous),
      rollback: () => updateEntity(previous, current),
    });
  }

  for (const [, extract] of subcollections(current)) {
    queue = queue.concat(collectionQueue({ type: `update`, current, previous }, extract));
  }
  return queue;
}

function getDeleteWork(entity: EditableEntity): WorkQueue {
  let queue: WorkQueue = [];
  queue.push({
    step: { description: `Delete ${entity.__typename}`, status: `not started` },
    exec: () => deleteEntity(entity),
    rollback: () => createEntity(entity),
  });

  for (const [, extract] of subcollections(entity)) {
    queue = queue.concat(collectionQueue({ type: `delete`, entity }, extract));
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
        queue = queue.concat(getCreateWork(item));
      }
      break;
    }
    case `update`: {
      const currentCollection = extract(operation.current);
      const previousCollection = extract(operation.previous);
      for (const newItem of currentCollection ?? []) {
        const prevItem = findIn(newItem, previousCollection);
        if (prevItem && !isEqual(newItem, prevItem)) {
          queue = queue.concat(getUpdateWork(newItem, prevItem));
        } else if (!prevItem) {
          queue = queue.concat(getCreateWork(newItem));
        }
      }
      for (const prevItem of previousCollection ?? []) {
        if (!findIn(prevItem, currentCollection)) {
          queue = queue.concat(getDeleteWork(prevItem));
        }
      }
      break;
    }
    case `delete`: {
      const collection = extract(operation.entity);
      for (const item of collection ?? []) {
        queue = queue.concat(getDeleteWork(item));
      }
      break;
    }
  }

  return queue;
}

function findIn<T extends EditableEntity>(entity: T, collection?: T[]): T | undefined {
  return (collection ?? []).find(same(entity));
}

function same<T extends EditableEntity>(entity: T): (item: T) => boolean {
  return (item) => item.id === entity.id && item.__typename === entity.__typename;
}

function getOperation<T extends EditableEntity>(current?: T, previous?: T): Operation<T> {
  if (current && !previous) {
    return { type: `create`, entity: current };
  } else if (current && previous) {
    return { type: `update`, previous, current };
  } else if (!current && previous) {
    return { type: `delete`, entity: previous };
  } else {
    throw new Error(`Invalid input to getOperation()`);
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
    default:
      return [];
  }
}

export async function perform(queue: WorkQueue, progress: Progress): Promise<void> {
  const updateProgress: (error?: string | null) => unknown = (error) =>
    progress(
      queue.map((item) => ({ ...item.step })),
      error ?? undefined,
    );

  const completed: WorkQueue = [];
  async function rollback(): Promise<void> {
    for (const completedItem of completed.reverse()) {
      const rollback = completedItem.rollback;
      if (rollback) {
        completedItem.step.status = `rolling back`;
        const rollbackError = await rollback();
        completedItem.step.status = rollbackError
          ? `rollback failed`
          : `rollback succeeded`;
        updateProgress(rollbackError);
      } else {
        completedItem.step.status = `no rollback`;
        updateProgress();
      }
    }
  }

  updateProgress();
  for (const item of queue) {
    item.step.status = `in flight`;
    updateProgress();
    const error = await item.exec();
    item.step.status = error === null ? `succeeded` : `failed`;
    updateProgress(error);
    if (error) {
      return rollback();
    }
    completed.push(item);
  }
}
