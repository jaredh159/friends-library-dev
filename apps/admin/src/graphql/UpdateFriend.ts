/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateFriendInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateFriend
// ====================================================

export interface UpdateFriend_friend {
  __typename: 'Friend';
  id: string;
}

export interface UpdateFriend {
  friend: UpdateFriend_friend;
}

export interface UpdateFriendVariables {
  input: UpdateFriendInput;
}
