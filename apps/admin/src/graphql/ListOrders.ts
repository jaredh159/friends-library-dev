/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { PrintJobStatus, OrderSource } from './globalTypes';

// ====================================================
// GraphQL query operation: ListOrders
// ====================================================

export interface ListOrders_orders {
  __typename: 'Order';
  id: string;
  amountInCents: number;
  addressName: string;
  printJobStatus: PrintJobStatus;
  source: OrderSource;
  createdAt: string;
}

export interface ListOrders {
  orders: ListOrders_orders[];
}
