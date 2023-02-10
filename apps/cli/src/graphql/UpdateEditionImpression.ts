/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateEditionImpressionInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateEditionImpression
// ====================================================

export interface UpdateEditionImpression_impression_files_paperback_cover {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface UpdateEditionImpression_impression_files_paperback_interior {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface UpdateEditionImpression_impression_files_paperback {
  __typename: 'EditionImpressionPaperbackFiles';
  cover: UpdateEditionImpression_impression_files_paperback_cover[];
  interior: UpdateEditionImpression_impression_files_paperback_interior[];
}

export interface UpdateEditionImpression_impression_files_ebook_epub {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface UpdateEditionImpression_impression_files_ebook_mobi {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface UpdateEditionImpression_impression_files_ebook_pdf {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface UpdateEditionImpression_impression_files_ebook_speech {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface UpdateEditionImpression_impression_files_ebook_app {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface UpdateEditionImpression_impression_files_ebook {
  __typename: 'EditionImpressionEbookFiles';
  epub: UpdateEditionImpression_impression_files_ebook_epub;
  mobi: UpdateEditionImpression_impression_files_ebook_mobi;
  pdf: UpdateEditionImpression_impression_files_ebook_pdf;
  speech: UpdateEditionImpression_impression_files_ebook_speech;
  app: UpdateEditionImpression_impression_files_ebook_app;
}

export interface UpdateEditionImpression_impression_files {
  __typename: 'EditionImpressionFiles';
  paperback: UpdateEditionImpression_impression_files_paperback;
  ebook: UpdateEditionImpression_impression_files_ebook;
}

export interface UpdateEditionImpression_impression {
  __typename: 'EditionImpression';
  files: UpdateEditionImpression_impression_files;
}

export interface UpdateEditionImpression {
  impression: UpdateEditionImpression_impression;
}

export interface UpdateEditionImpressionVariables {
  input: UpdateEditionImpressionInput;
}
