/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateFriendResidenceInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateFriendResidence
// ====================================================

export interface UpdateFriendResidence_residence {
  __typename: 'FriendResidence';
  id: string;
}

export interface UpdateFriendResidence {
  residence: UpdateFriendResidence_residence;
}

export interface UpdateFriendResidenceVariables {
  input: UpdateFriendResidenceInput;
}
