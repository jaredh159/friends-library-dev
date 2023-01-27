/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetDocumentDownloadCounts
// ====================================================

export interface GetDocumentDownloadCounts_counts {
  __typename: 'DocumentDownloadCount';
  documentId: string;
  downloadCount: number;
}

export interface GetDocumentDownloadCounts {
  counts: GetDocumentDownloadCounts_counts[];
}
