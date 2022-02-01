/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { EditionType, Lang, PrintSizeVariant } from './globalTypes';

// ====================================================
// GraphQL query operation: GetOrderEditions
// ====================================================

export interface GetOrderEditions_editions_document_friend {
  __typename: 'Friend';
  name: string;
  lang: Lang;
}

export interface GetOrderEditions_editions_document {
  __typename: 'Document';
  title: string;
  trimmedUtf8ShortTitle: string;
  friend: GetOrderEditions_editions_document_friend;
}

export interface GetOrderEditions_editions_impression {
  __typename: 'EditionImpression';
  paperbackPriceInCents: number;
  paperbackSize: PrintSizeVariant;
  paperbackVolumes: number[];
}

export interface GetOrderEditions_editions_images_threeD_small {
  __typename: 'EditionImage';
  url: string;
}

export interface GetOrderEditions_editions_images_threeD_large {
  __typename: 'EditionImage';
  url: string;
}

export interface GetOrderEditions_editions_images_threeD {
  __typename: 'EditionThreeDImages';
  small: GetOrderEditions_editions_images_threeD_small;
  large: GetOrderEditions_editions_images_threeD_large;
}

export interface GetOrderEditions_editions_images {
  __typename: 'EditionImages';
  threeD: GetOrderEditions_editions_images_threeD;
}

export interface GetOrderEditions_editions {
  __typename: 'Edition';
  id: string;
  type: EditionType;
  document: GetOrderEditions_editions_document;
  impression: GetOrderEditions_editions_impression | null;
  images: GetOrderEditions_editions_images;
}

export interface GetOrderEditions {
  editions: GetOrderEditions_editions[];
}
