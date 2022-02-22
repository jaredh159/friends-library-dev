/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { PrintJobStatus, Lang, OrderSource, EditionType } from './globalTypes';

// ====================================================
// GraphQL query operation: ViewOrder
// ====================================================

export interface ViewOrder_order_address {
  __typename: 'ShippingAddress';
  name: string;
  street: string;
  street2: string | null;
  city: string;
  state: string;
  zip: string;
  country: string;
}

export interface ViewOrder_order_items_edition_document_friend {
  __typename: 'Friend';
  name: string;
}

export interface ViewOrder_order_items_edition_document {
  __typename: 'Document';
  title: string;
  friend: ViewOrder_order_items_edition_document_friend;
}

export interface ViewOrder_order_items_edition_images_threeD_w250 {
  __typename: 'EditionImage';
  width: number;
  height: number;
  url: string;
}

export interface ViewOrder_order_items_edition_images_threeD {
  __typename: 'EditionThreeDImages';
  w250: ViewOrder_order_items_edition_images_threeD_w250;
}

export interface ViewOrder_order_items_edition_images {
  __typename: 'EditionImages';
  threeD: ViewOrder_order_items_edition_images_threeD;
}

export interface ViewOrder_order_items_edition {
  __typename: 'Edition';
  type: EditionType;
  document: ViewOrder_order_items_edition_document;
  images: ViewOrder_order_items_edition_images;
}

export interface ViewOrder_order_items {
  __typename: 'OrderItem';
  id: string;
  quantity: number;
  unitPrice: number;
  edition: ViewOrder_order_items_edition;
}

export interface ViewOrder_order {
  __typename: 'Order';
  id: string;
  printJobStatus: PrintJobStatus;
  printJobId: number | null;
  amount: number;
  shipping: number;
  taxes: number;
  ccFeeOffset: number;
  paymentId: string;
  email: string;
  address: ViewOrder_order_address;
  lang: Lang;
  source: OrderSource;
  createdAt: string;
  items: ViewOrder_order_items[];
}

export interface ViewOrder {
  order: ViewOrder_order;
}

export interface ViewOrderVariables {
  id: UUID;
}
