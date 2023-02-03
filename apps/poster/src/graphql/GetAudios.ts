/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { EditionType, Lang, PrintSize } from './globalTypes';

// ====================================================
// GraphQL query operation: GetAudios
// ====================================================

export interface GetAudios_audios_parts {
  __typename: 'AudioPart';
  title: string;
}

export interface GetAudios_audios_edition_isbn {
  __typename: 'Isbn';
  code: string;
}

export interface GetAudios_audios_edition_document_friend {
  __typename: 'Friend';
  lang: Lang;
  isCompilations: boolean;
  name: string;
}

export interface GetAudios_audios_edition_document {
  __typename: 'Document';
  description: string;
  title: string;
  directoryPath: string;
  friend: GetAudios_audios_edition_document_friend;
}

export interface GetAudios_audios_edition_impression {
  __typename: 'EditionImpression';
  paperbackSize: PrintSize;
  paperbackVolumes: number[];
}

export interface GetAudios_audios_edition {
  __typename: 'Edition';
  type: EditionType;
  isDraft: boolean;
  path: string;
  isbn: GetAudios_audios_edition_isbn | null;
  document: GetAudios_audios_edition_document;
  impression: GetAudios_audios_edition_impression | null;
}

export interface GetAudios_audios {
  __typename: 'Audio';
  parts: GetAudios_audios_parts[];
  edition: GetAudios_audios_edition;
}

export interface GetAudios {
  audios: GetAudios_audios[];
}
