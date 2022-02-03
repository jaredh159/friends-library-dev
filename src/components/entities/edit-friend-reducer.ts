import { EditFriend as EditFriendQueryResult } from '../../graphql/EditFriend';
import set from 'lodash.set';
import get from 'lodash.get';
import produce from 'immer';

type State = EditFriendQueryResult['friend'];

type Action =
  | { type: `collection_append`; at: string; value: unknown }
  | { type: `replace_value`; at: string; with: unknown }
  | { type: `update_year`; at: string; with: string };

export default function reducer(baseState: State, action: Action): State {
  return produce(baseState, (state) => {
    switch (action.type) {
      case `update_year`:
        const year = nullableYear(action.with);
        set(state, action.at, year);
        break;
      case `replace_value`:
        set(state, action.at, action.with);
        break;
      case `collection_append`:
        const collection: unknown[] = get(state, action.at);
        collection.push(action.value);
        break;
      default:
        throw new Error(`WIP`);
    }
  });
}

// helpers

export function isValidYear(input: string): boolean {
  const number = nullableYear(input);
  if (number === null) {
    return false;
  }
  return number > 1600 && number < 1900;
}

function nullableYear(input: string): number | null {
  if (input.trim() === ``) {
    return null;
  }
  const date = Number(input);
  if (Number.isNaN(date) || !Number.isInteger(date)) {
    return null;
  }

  return date;
}
