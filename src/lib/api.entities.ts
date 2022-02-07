import { gql } from '@apollo/client';
import omit from 'lodash.omit';
import isEqual from 'lodash.isequal';
import client from '../client';
import {
  EditableDocument,
  EditableEntity,
  EditableFriend,
  EditableFriendResidence,
  MutationStep,
} from '../types';

type ErrorMsg = string;
type Progress = (steps: MutationStep[], error?: string) => unknown;
type StepExec = () => Promise<ErrorMsg | null>;
type WorkItem = { step: MutationStep; exec: StepExec; rollback?: StepExec };
type WorkQueue = Array<WorkItem>;

export async function updateFriendHeirarchy(
  current: EditableFriend,
  previous: EditableFriend,
  progress: Progress,
): Promise<void> {
  let queue: WorkQueue = [];

  const children = [`quotes`, `documents`, `residences`];
  if (!isEqual(omit(current, children), omit(previous, children))) {
    queue.push({
      step: { description: `Update Friend data`, status: `not started` },
      exec: () => updateFriend(current),
      rollback: () => updateFriend(previous),
    });
  }

  queue = queue.concat(collectionQueue(current.quotes, previous.quotes));
  queue = queue.concat(collectionQueue(current.residences, previous.residences));
  queue = queue.concat(collectionQueue(current.documents, previous.documents));

  await perform(queue, progress);
}

function handleSubCollections<T extends EditableEntity>(
  current?: T,
  previous?: T,
): WorkQueue {
  const instance = current ?? previous;
  if (!instance) return [];
  switch (instance.__typename) {
    case `Document`:
      const curDoc = current as EditableDocument;
      const prevDoc = previous as EditableDocument;
      return collectionQueue(curDoc?.editions, prevDoc?.editions)
        .concat(collectionQueue(curDoc?.relatedDocuments, prevDoc?.relatedDocuments))
        .concat(collectionQueue(curDoc?.tags, prevDoc?.tags));
    case `FriendResidence`:
      return collectionQueue(
        (current as EditableFriendResidence)?.durations,
        (previous as EditableFriendResidence)?.durations,
      );
  }
  return [];
}

// todo, can i remove generic?
function collectionQueue<T extends EditableEntity>(
  current: T[] | undefined,
  previous: T[] | undefined,
): WorkQueue {
  let queue: WorkQueue = [];

  // if sub-items are deeply equal, don't do anything
  if (isEqual(current, previous)) {
    return queue;
  }

  for (const newItem of current ?? []) {
    const prevItem = findIn(newItem, previous);
    if (prevItem && !isEqual(newItem, prevItem)) {
      // 1) item was updated, update it
      queue = queue.concat(updateEntityQueue(newItem));
      queue = queue.concat(handleSubCollections(newItem, prevItem));
    } else if (!prevItem) {
      // 2) item was added, create it
      queue = queue.concat(createEntityQueue(newItem));
      queue = queue.concat(handleSubCollections(newItem, undefined));
    }
  }

  for (const prevItem of previous ?? []) {
    if (!findIn(prevItem, current)) {
      // 3) item was deleted, delete it
      queue = queue.concat(deleteEntityQueue(prevItem));
      queue = queue.concat(handleSubCollections(undefined, prevItem));
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

function deleteEntityQueue(entity: EditableEntity): WorkQueue {
  return [];
}

function createEntityQueue(entity: EditableEntity): WorkQueue {
  return [];
}

function updateEntityQueue(entity: EditableEntity): WorkQueue {
  switch (entity.__typename) {
    case `Friend`:
      return updateFriendQueue(entity);
    default:
      throw new Error(`Unhandled updateEntity() type: \`${entity.__typename}\``);
  }
}

function updateFriendQueue(friend: EditableFriend): WorkQueue {
  return [];
}

async function updateFriend(friend: EditableFriend): Promise<ErrorMsg | null> {
  return null;
}

const UPDATE_FRIEND = gql`
  mutation UpdateFriend($input: UpdateFriendInput!) {
    friend: updateFriend(input: $input) {
      id
    }
  }
`;

async function perform(queue: WorkQueue, progress: Progress): Promise<void> {
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
