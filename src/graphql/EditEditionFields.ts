/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { EditionType, PrintSizeVariant } from './globalTypes';

// ====================================================
// GraphQL fragment: EditEditionFields
// ====================================================

export interface EditEditionFields_isbn {
  __typename: 'Isbn';
  code: string;
}

export interface EditEditionFields_document {
  __typename: 'Document';
  id: string;
}

export interface EditEditionFields_audio_edition {
  __typename: 'Edition';
  id: string;
}

export interface EditEditionFields_audio_parts_audio {
  __typename: 'Audio';
  id: string;
}

export interface EditEditionFields_audio_parts {
  __typename: 'AudioPart';
  id: string;
  order: number;
  title: string;
  duration: number;
  chapters: number[];
  mp3SizeHq: number;
  mp3SizeLq: number;
  externalIdHq: Int64;
  externalIdLq: Int64;
  audio: EditEditionFields_audio_parts_audio;
}

export interface EditEditionFields_audio {
  __typename: 'Audio';
  id: string;
  reader: string;
  isIncomplete: boolean;
  mp3ZipSizeHq: number;
  mp3ZipSizeLq: number;
  m4bSizeHq: number;
  m4bSizeLq: number;
  externalPlaylistIdHq: Int64 | null;
  externalPlaylistIdLq: Int64 | null;
  edition: EditEditionFields_audio_edition;
  parts: EditEditionFields_audio_parts[];
}

export interface EditEditionFields {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  paperbackSplits: number[] | null;
  paperbackOverrideSize: PrintSizeVariant | null;
  editor: string | null;
  isbn: EditEditionFields_isbn | null;
  isDraft: boolean;
  document: EditEditionFields_document;
  audio: EditEditionFields_audio | null;
}
