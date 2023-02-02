/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { CreateOrderInput, CreateOrderItemInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: CreateOrderWithItems
// ====================================================

export interface CreateOrderWithItems_order {
  __typename: 'Order';
  id: string;
}

export interface CreateOrderWithItems {
  order: CreateOrderWithItems_order;
}

export interface CreateOrderWithItemsVariables {
  order: CreateOrderInput;
  items: CreateOrderItemInput[];
}
