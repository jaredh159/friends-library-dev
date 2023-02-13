import { createReducer } from 'redux-starter-kit';
import type { Action } from '../type';
import * as screens from '../screens';

export default createReducer(screens.TASKS, {
  CHANGE_SCREEN: (state: string, action: Action) => action.payload,
  WORK_ON_TASK: () => screens.WORK,
});
