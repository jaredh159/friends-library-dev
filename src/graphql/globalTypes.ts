/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

//==============================================================
// START Enums and Input Objects
//==============================================================

export enum EditionType {
  modernized = 'modernized',
  original = 'original',
  updated = 'updated',
}

export enum Lang {
  en = 'en',
  es = 'es',
}

export enum TagType {
  allegory = 'allegory',
  doctrinal = 'doctrinal',
  exhortation = 'exhortation',
  history = 'history',
  journal = 'journal',
  letters = 'letters',
  spiritualLife = 'spiritualLife',
  treatise = 'treatise',
}

export interface UpdateAudioInput {
  editionId: UUID;
  externalPlaylistIdHq?: Int64 | null;
  externalPlaylistIdLq?: Int64 | null;
  id: UUID;
  isIncomplete: boolean;
  m4bSizeHq: number;
  m4bSizeLq: number;
  mp3ZipSizeHq: number;
  mp3ZipSizeLq: number;
  reader: string;
}

export interface UpdateAudioPartInput {
  audioId: UUID;
  chapters: number[];
  duration: number;
  externalIdHq: Int64;
  externalIdLq: Int64;
  id: UUID;
  mp3SizeHq: number;
  mp3SizeLq: number;
  order: number;
  title: string;
}

//==============================================================
// END Enums and Input Objects
//==============================================================
