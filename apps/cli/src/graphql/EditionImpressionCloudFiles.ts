/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL fragment: EditionImpressionCloudFiles
// ====================================================

export interface EditionImpressionCloudFiles_files_paperback_cover {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface EditionImpressionCloudFiles_files_paperback_interior {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface EditionImpressionCloudFiles_files_paperback {
  __typename: 'EditionImpressionPaperbackFiles';
  cover: EditionImpressionCloudFiles_files_paperback_cover[];
  interior: EditionImpressionCloudFiles_files_paperback_interior[];
}

export interface EditionImpressionCloudFiles_files_ebook_epub {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface EditionImpressionCloudFiles_files_ebook_mobi {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface EditionImpressionCloudFiles_files_ebook_pdf {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface EditionImpressionCloudFiles_files_ebook_speech {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface EditionImpressionCloudFiles_files_ebook_app {
  __typename: 'DownloadableFile';
  cloudPath: string;
}

export interface EditionImpressionCloudFiles_files_ebook {
  __typename: 'EditionImpressionEbookFiles';
  epub: EditionImpressionCloudFiles_files_ebook_epub;
  mobi: EditionImpressionCloudFiles_files_ebook_mobi;
  pdf: EditionImpressionCloudFiles_files_ebook_pdf;
  speech: EditionImpressionCloudFiles_files_ebook_speech;
  app: EditionImpressionCloudFiles_files_ebook_app;
}

export interface EditionImpressionCloudFiles_files {
  __typename: 'EditionImpressionFiles';
  paperback: EditionImpressionCloudFiles_files_paperback;
  ebook: EditionImpressionCloudFiles_files_ebook;
}

export interface EditionImpressionCloudFiles {
  __typename: 'EditionImpression';
  files: EditionImpressionCloudFiles_files;
}
