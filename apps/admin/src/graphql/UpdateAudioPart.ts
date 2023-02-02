/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateAudioPartInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateAudioPart
// ====================================================

export interface UpdateAudioPart_part {
  __typename: 'AudioPart';
  id: string;
}

export interface UpdateAudioPart {
  part: UpdateAudioPart_part;
}

export interface UpdateAudioPartVariables {
  input: UpdateAudioPartInput;
}
