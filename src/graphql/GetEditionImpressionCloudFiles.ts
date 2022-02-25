/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetEditionImpressionCloudFiles
// ====================================================

export interface GetEditionImpressionCloudFiles_impression_files_paperback_cover {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface GetEditionImpressionCloudFiles_impression_files_paperback_interior {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface GetEditionImpressionCloudFiles_impression_files_paperback {
  __typename: 'EditionImpressionPaperbackFiles';
  cover: GetEditionImpressionCloudFiles_impression_files_paperback_cover[];
  interior: GetEditionImpressionCloudFiles_impression_files_paperback_interior[];
}

export interface GetEditionImpressionCloudFiles_impression_files_ebook_epub {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface GetEditionImpressionCloudFiles_impression_files_ebook_mobi {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface GetEditionImpressionCloudFiles_impression_files_ebook_pdf {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface GetEditionImpressionCloudFiles_impression_files_ebook_speech {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface GetEditionImpressionCloudFiles_impression_files_ebook_app {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface GetEditionImpressionCloudFiles_impression_files_ebook {
  __typename: 'EditionImpressionEbookFiles';
  epub: GetEditionImpressionCloudFiles_impression_files_ebook_epub;
  mobi: GetEditionImpressionCloudFiles_impression_files_ebook_mobi;
  pdf: GetEditionImpressionCloudFiles_impression_files_ebook_pdf;
  speech: GetEditionImpressionCloudFiles_impression_files_ebook_speech;
  app: GetEditionImpressionCloudFiles_impression_files_ebook_app;
}

export interface GetEditionImpressionCloudFiles_impression_files {
  __typename: 'EditionImpressionFiles';
  paperback: GetEditionImpressionCloudFiles_impression_files_paperback;
  ebook: GetEditionImpressionCloudFiles_impression_files_ebook;
}

export interface GetEditionImpressionCloudFiles_impression {
  __typename: 'EditionImpression';
  files: GetEditionImpressionCloudFiles_impression_files;
}

export interface GetEditionImpressionCloudFiles {
  impression: GetEditionImpressionCloudFiles_impression;
}

export interface GetEditionImpressionCloudFilesVariables {
  id: UUID;
}
