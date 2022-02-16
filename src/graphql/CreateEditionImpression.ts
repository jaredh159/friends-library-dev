/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { CreateEditionImpressionInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: CreateEditionImpression
// ====================================================

export interface CreateEditionImpression_impression_files_paperback_cover {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface CreateEditionImpression_impression_files_paperback_interior {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface CreateEditionImpression_impression_files_paperback {
  __typename: 'EditionImpressionPaperbackFiles';
  cover: CreateEditionImpression_impression_files_paperback_cover[];
  interior: CreateEditionImpression_impression_files_paperback_interior[];
}

export interface CreateEditionImpression_impression_files_ebook_epub {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface CreateEditionImpression_impression_files_ebook_mobi {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface CreateEditionImpression_impression_files_ebook_pdf {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface CreateEditionImpression_impression_files_ebook_speech {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface CreateEditionImpression_impression_files_ebook_app {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface CreateEditionImpression_impression_files_ebook {
  __typename: 'EditionImpressionEbookFiles';
  epub: CreateEditionImpression_impression_files_ebook_epub;
  mobi: CreateEditionImpression_impression_files_ebook_mobi;
  pdf: CreateEditionImpression_impression_files_ebook_pdf;
  speech: CreateEditionImpression_impression_files_ebook_speech;
  app: CreateEditionImpression_impression_files_ebook_app;
}

export interface CreateEditionImpression_impression_files {
  __typename: 'EditionImpressionFiles';
  paperback: CreateEditionImpression_impression_files_paperback;
  ebook: CreateEditionImpression_impression_files_ebook;
}

export interface CreateEditionImpression_impression {
  __typename: 'EditionImpression';
  files: CreateEditionImpression_impression_files;
}

export interface CreateEditionImpression {
  impression: CreateEditionImpression_impression;
}

export interface CreateEditionImpressionVariables {
  input: CreateEditionImpressionInput;
}
