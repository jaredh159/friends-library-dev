import isEqual from 'lodash.isequal';
import omit from 'lodash.omit';
import type {
  EditableEntity,
  Progress,
  WorkQueue,
  EntityOperation,
  CreateOperation,
  UpdateOperation,
  DeleteOperation,
} from '../../../types';
import { createEntity, deleteEntity, updateEntity } from './crud.entities';

export async function save(
  progress: Progress,
  current?: EditableEntity,
  previous?: EditableEntity,
): Promise<void> {
  return perform(getWork(current, previous), progress);
}

function getWork(
  current: EditableEntity | undefined,
  previous: EditableEntity | undefined,
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

function getCreateWork(operation: CreateOperation): WorkQueue {
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

function getUpdateWork(op: UpdateOperation): WorkQueue {
  let queue: WorkQueue = [];
  const omitKeys = omittable(op.current);
  if (!isEqual(omit(op.current.entity, omitKeys), omit(op.previous.entity, omitKeys))) {
    queue.push({ operation: op, status: `not started` });
  }
  for (const [, extract] of subcollections(op.current)) {
    queue = queue.concat(collectionQueue(op, extract));
  }
  for (const [, extract] of optionalChildren(op.current)) {
    const current = extract(op.current);
    const prev = extract(op.previous);
    queue = queue.concat(getWork(current ?? undefined, prev ?? undefined));
  }
  return queue;
}

function getDeleteWork(operation: DeleteOperation): WorkQueue {
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

function collectionQueue(
  operation: EntityOperation,
  extract: (root: EditableEntity) => EditableEntity[] | undefined,
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

function getOperation(
  current?: EditableEntity,
  previous?: EditableEntity,
): EntityOperation {
  if (previous?.entity.id.startsWith(`_`)) {
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
): Array<[key: string, extractor: (root: EditableEntity) => EditableEntity | null]> {
  switch (entity.case) {
    case `edition`:
      return [
        [
          `audio`,
          (editable) => {
            if (editable.case !== `edition`) throw new Error(`Expected edition`);
            return editable.entity.audio
              ? { case: `audio`, entity: editable.entity.audio }
              : null;
          },
        ],
      ];
    case `friend`:
    case `friendResidence`:
    case `document`:
    case `audio`:
    case `audioPart`:
    case `friendQuote`:
    case `friendResidenceDuration`:
    case `relatedDocument`:
    case `documentTag`:
    case `token`:
    case `tokenScope`:
      return [];
  }
}

function mapEditable<E, T>(entities: E[], type: T): Array<{ case: T; entity: E }> {
  return entities.map((entity) => ({ case: type, entity }));
}

function subcollections(
  entity: EditableEntity,
): Array<
  [key: string, extractor: (root: EditableEntity) => EditableEntity[] | undefined]
> {
  switch (entity.case) {
    case `friend`:
      return [
        [
          `quotes`,
          (editable) => {
            if (editable.case !== `friend`) throw new Error(`Expected friend`);
            return mapEditable(editable.entity.quotes, `friendQuote`);
          },
        ],
        [
          `documents`,
          (editable) => {
            if (editable.case !== `friend`) throw new Error(`Expected friend`);
            return mapEditable(editable.entity.documents, `document`);
          },
        ],
        [
          `residences`,
          (editable) => {
            if (editable.case !== `friend`) throw new Error(`Expected friend`);
            return mapEditable(editable.entity.residences, `friendResidence`);
          },
        ],
      ];
    case `friendResidence`:
      return [
        [
          `durations`,
          (editable) => {
            if (editable.case !== `friendResidence`)
              throw new Error(`Expected friendResidence`);
            return mapEditable(editable.entity.durations, `friendResidenceDuration`);
          },
        ],
      ];
    case `document`:
      return [
        [
          `editions`,
          (editable) => {
            if (editable.case !== `document`) throw new Error(`Expected document`);
            return mapEditable(editable.entity.editions, `edition`);
          },
        ],
        [
          `relatedDocuments`,
          (editable) => {
            if (editable.case !== `document`) throw new Error(`Expected document`);
            return mapEditable(editable.entity.relatedDocuments, `relatedDocument`);
          },
        ],
        [
          `tags`,
          (editable) => {
            if (editable.case !== `document`) throw new Error(`Expected document`);
            return mapEditable(editable.entity.tags, `documentTag`);
          },
        ],
      ];
    case `audio`:
      return [
        [
          `parts`,
          (editable) => {
            if (editable.case !== `audio`) throw new Error(`Expected audio`);
            return mapEditable(editable.entity.parts, `audioPart`);
          },
        ],
      ];
    case `token`:
      return [
        [
          `scopes`,
          (editable) => {
            if (editable.case !== `token`) throw new Error(`Expected token`);
            return mapEditable(editable.entity.scopes, `tokenScope`);
          },
        ],
      ];
    case `friendQuote`:
    case `friendResidenceDuration`:
    case `relatedDocument`:
    case `documentTag`:
    case `edition`:
    case `audioPart`:
    case `tokenScope`:
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

function findIn(
  entity: EditableEntity,
  collection?: EditableEntity[],
): EditableEntity | undefined {
  return (collection ?? []).find(same(entity));
}

function same(test: EditableEntity): (item: EditableEntity) => boolean {
  return (item) => item.entity.id === test.entity.id && item.case === test.case;
}
