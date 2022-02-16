/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { PrintSizeVariant } from './globalTypes';

// ====================================================
// GraphQL query operation: PublishEdition
// ====================================================

export interface PublishEdition_edition_images_square_all {
  __typename: 'EditionImage';
  width: number;
  filename: string;
  path: string;
}

export interface PublishEdition_edition_images_square {
  __typename: 'EditionSquareImages';
  all: PublishEdition_edition_images_square_all[];
}

export interface PublishEdition_edition_images_threeD_all {
  __typename: 'EditionImage';
  width: number;
  filename: string;
  path: string;
}

export interface PublishEdition_edition_images_threeD {
  __typename: 'EditionThreeDImages';
  all: PublishEdition_edition_images_threeD_all[];
}

export interface PublishEdition_edition_images {
  __typename: 'EditionImages';
  square: PublishEdition_edition_images_square;
  threeD: PublishEdition_edition_images_threeD;
}

export interface PublishEdition_edition_impression {
  __typename: 'EditionImpression';
  id: string;
  adocLength: number;
  paperbackSize: PrintSizeVariant;
  paperbackVolumes: number[];
  publishedRevision: string;
  productionToolchainRevision: string;
}

export interface PublishEdition_edition_document {
  __typename: 'Document';
  filename: string;
}

export interface PublishEdition_edition {
  __typename: 'Edition';
  isDraft: boolean;
  images: PublishEdition_edition_images;
  impression: PublishEdition_edition_impression | null;
  document: PublishEdition_edition_document;
}

export interface PublishEdition {
  edition: PublishEdition_edition;
}

export interface PublishEditionVariables {
  id: UUID;
}
