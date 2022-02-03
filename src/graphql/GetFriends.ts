/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang } from './globalTypes';

// ====================================================
// GraphQL query operation: GetFriends
// ====================================================

export interface GetFriends_friends {
  __typename: 'Friend';
  id: string;
  name: string;
  alphabeticalName: string;
  lang: Lang;
}

export interface GetFriends {
  friends: GetFriends_friends[];
}
