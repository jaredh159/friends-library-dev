/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateFriendResidenceDurationInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateFriendResidenceDuration
// ====================================================

export interface UpdateFriendResidenceDuration_duration {
  __typename: 'FriendResidenceDuration';
  id: string;
}

export interface UpdateFriendResidenceDuration {
  duration: UpdateFriendResidenceDuration_duration;
}

export interface UpdateFriendResidenceDurationVariables {
  input: UpdateFriendResidenceDurationInput;
}
