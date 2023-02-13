import type { SavedState } from '../type';
import prNumberToPullRequestObject from './pr-number-to-pull-request-object';

export default function migrate(state: Partial<SavedState>): Partial<SavedState> {
  const migrations = [prNumberToPullRequestObject];
  let newState = state;

  migrations.forEach((migration) => {
    newState = migration(newState);
  });

  return newState;
}
