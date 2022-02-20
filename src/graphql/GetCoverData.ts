/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { EditionType, PrintSize } from './globalTypes';

// ====================================================
// GraphQL query operation: GetCoverData
// ====================================================

export interface GetCoverData_edition_impression {
  __typename: 'EditionImpression';
  paperbackVolumes: number[];
  paperbackSize: PrintSize;
}

export interface GetCoverData_edition {
  __typename: 'Edition';
  type: EditionType;
  impression: GetCoverData_edition_impression | null;
}

export interface GetCoverData {
  edition: GetCoverData_edition;
}

export interface GetCoverDataVariables {
  id: UUID;
}
