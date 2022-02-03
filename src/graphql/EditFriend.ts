/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Gender } from './globalTypes';

// ====================================================
// GraphQL query operation: EditFriend
// ====================================================

export interface EditFriend_friend_quotes {
  __typename: 'FriendQuote';
  id: string;
  source: string;
  text: string;
  order: number;
}

export interface EditFriend_friend {
  __typename: 'Friend';
  name: string;
  slug: string;
  gender: Gender;
  born: number | null;
  died: number | null;
  description: string;
  quotes: EditFriend_friend_quotes[];
}

export interface EditFriend {
  friend: EditFriend_friend;
}

export interface EditFriendVariables {
  id: UUID;
}
