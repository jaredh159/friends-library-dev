/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { Lang, EditionType, PrintSizeVariant, TagType } from './globalTypes';

// ====================================================
// GraphQL query operation: EditDocument
// ====================================================

export interface EditDocument_document_friend {
  __typename: 'Friend';
  id: string;
  name: string;
  lang: Lang;
}

export interface EditDocument_document_editions_isbn {
  __typename: 'Isbn';
  code: string;
}

export interface EditDocument_document_editions {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  paperbackSplits: number[] | null;
  paperbackOverrideSize: PrintSizeVariant | null;
  isbn: EditDocument_document_editions_isbn | null;
  isDraft: boolean;
}

export interface EditDocument_document_tags {
  __typename: 'DocumentTag';
  id: string;
  type: TagType;
}

export interface EditDocument_document_relatedDocuments {
  __typename: 'RelatedDocument';
  id: string;
  description: string;
  documentId: string;
}

export interface EditDocument_document {
  __typename: 'Document';
  id: string;
  altLanguageId: string | null;
  title: string;
  slug: string;
  filename: string;
  published: number | null;
  originalTitle: string | null;
  incomplete: boolean;
  description: string;
  partialDescription: string;
  featuredDescription: string | null;
  friend: EditDocument_document_friend;
  editions: EditDocument_document_editions[];
  tags: EditDocument_document_tags[];
  relatedDocuments: EditDocument_document_relatedDocuments[];
}

export interface EditDocument_selectableDocuments_friend {
  __typename: 'Friend';
  lang: Lang;
  alphabeticalName: string;
}

export interface EditDocument_selectableDocuments {
  __typename: 'Document';
  id: string;
  title: string;
  friend: EditDocument_selectableDocuments_friend;
}

export interface EditDocument {
  document: EditDocument_document;
  selectableDocuments: EditDocument_selectableDocuments[];
}

export interface EditDocumentVariables {
  id: UUID;
}
