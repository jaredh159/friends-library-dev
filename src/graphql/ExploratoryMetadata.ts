/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { GetPrintJobExploratoryMetadataInput, ShippingLevel } from './globalTypes';

// ====================================================
// GraphQL query operation: ExploratoryMetadata
// ====================================================

export interface ExploratoryMetadata_data {
  __typename: 'PrintJobExploratoryMetadata';
  shippingLevel: ShippingLevel;
  shippingInCents: number;
  taxesInCents: number;
  feesInCents: number;
  creditCardFeeOffsetInCents: number;
}

export interface ExploratoryMetadata {
  data: ExploratoryMetadata_data;
}

export interface ExploratoryMetadataVariables {
  input: GetPrintJobExploratoryMetadataInput;
}
