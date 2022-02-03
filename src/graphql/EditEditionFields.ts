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

export interface EditEditionFields {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  paperbackSplits: number[] | null;
  paperbackOverrideSize: PrintSizeVariant | null;
  isbn: EditEditionFields_isbn | null;
  isDraft: boolean;
}
