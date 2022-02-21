/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteFriend
// ====================================================

export interface DeleteFriend_friend {
  __typename: 'Friend';
  id: string;
}

export interface DeleteFriend {
  friend: DeleteFriend_friend;
}

export interface DeleteFriendVariables {
  id: UUID;
}
