/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { EditionType, TagType, Lang } from './globalTypes';

// ====================================================
// GraphQL query operation: GetAudios
// ====================================================

export interface GetAudios_audios_parts {
  __typename: 'AudioPart';
  id: string;
  chapters: number[];
  duration: number;
  title: string;
  order: number;
  externalIdHq: Int64;
  externalIdLq: Int64;
  mp3SizeHq: number;
  mp3SizeLq: number;
}

export interface GetAudios_audios_edition_images_square_w1400 {
  __typename: 'EditionImage';
  path: string;
}

export interface GetAudios_audios_edition_images_square {
  __typename: 'EditionSquareImages';
  w1400: GetAudios_audios_edition_images_square_w1400;
}

export interface GetAudios_audios_edition_images {
  __typename: 'EditionImages';
  square: GetAudios_audios_edition_images_square;
}

export interface GetAudios_audios_edition_document_tags {
  __typename: 'DocumentTag';
  type: TagType;
}

export interface GetAudios_audios_edition_document_friend {
  __typename: 'Friend';
  lang: Lang;
  name: string;
  slug: string;
  alphabeticalName: string;
  isCompilations: boolean;
}

export interface GetAudios_audios_edition_document {
  __typename: 'Document';
  filename: string;
  title: string;
  slug: string;
  description: string;
  path: string;
  tags: GetAudios_audios_edition_document_tags[];
  friend: GetAudios_audios_edition_document_friend;
}

export interface GetAudios_audios_edition {
  __typename: 'Edition';
  id: string;
  path: string;
  type: EditionType;
  images: GetAudios_audios_edition_images;
  document: GetAudios_audios_edition_document;
}

export interface GetAudios_audios {
  __typename: 'Audio';
  id: string;
  isIncomplete: boolean;
  m4bSizeHq: number;
  m4bSizeLq: number;
  mp3ZipSizeHq: number;
  mp3ZipSizeLq: number;
  reader: string;
  externalPlaylistIdHq: Int64 | null;
  externalPlaylistIdLq: Int64 | null;
  parts: GetAudios_audios_parts[];
  edition: GetAudios_audios_edition;
}

export interface GetAudios {
  audios: GetAudios_audios[];
}
