/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateAudioInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateAudio
// ====================================================

export interface UpdateAudio_audio {
  __typename: 'Audio';
  id: string;
}

export interface UpdateAudio {
  audio: UpdateAudio_audio;
}

export interface UpdateAudioVariables {
  input: UpdateAudioInput;
}
