/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { GetPrintJobExploratoryMetadataInput, ShippingLevel } from './globalTypes';

// ====================================================
// GraphQL query operation: GetPrintJobExploratoryMetadata
// ====================================================

export interface GetPrintJobExploratoryMetadata_metadata {
  __typename: 'PrintJobExploratoryMetadata';
  shippingLevel: ShippingLevel;
  shippingInCents: number;
  taxesInCents: number;
  feesInCents: number;
}

export interface GetPrintJobExploratoryMetadata {
  metadata: GetPrintJobExploratoryMetadata_metadata;
}

export interface GetPrintJobExploratoryMetadataVariables {
  input: GetPrintJobExploratoryMetadataInput;
}
