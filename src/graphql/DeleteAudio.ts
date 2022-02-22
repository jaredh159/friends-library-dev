/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteAudio
// ====================================================

export interface DeleteAudio_audio {
  __typename: 'Audio';
  id: string;
}

export interface DeleteAudio {
  audio: DeleteAudio_audio;
}

export interface DeleteAudioVariables {
  id: UUID;
}
