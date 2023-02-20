import set from 'lodash.set';
import get from 'lodash.get';
import produce from 'immer';
import type { Action } from '../types';

export default function reducer<State extends object>(
  baseState: State,
  action: Action<State>,
): State {
  if (action.type === `replace`) {
    return action.state;
  }
  return produce(baseState, (state) => {
    switch (action.type) {
      case `update_year`: {
        const year = nullableYear(action.with);
        set(state, action.at, year);
        break;
      }
      case `replace_value`:
        set(state, action.at, action.with);
        break;
      case `add_item`: {
        const collection: unknown[] = get(state, action.at);
        collection.push(action.value);
        break;
      }
      case `delete_item`: {
        const indexMatch = action.at.match(/\[(\d+)\]$/);
        if (!indexMatch) return;
        const collectionPath = action.at.replace(/\[\d+\]$/, ``);
        const collection: unknown[] = get(state, collectionPath);
        collection.splice(Number(indexMatch[1]), 1);
        break;
      }
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
