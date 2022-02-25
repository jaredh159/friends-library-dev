/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { CreateOrderInitializationInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: CreateOrderInit
// ====================================================

export interface CreateOrderInit_data {
  __typename: 'OrderInitialization';
  orderId: string;
  orderPaymentId: string;
  stripeClientSecret: string;
  token: string;
}

export interface CreateOrderInit {
  data: CreateOrderInit_data;
}

export interface CreateOrderInitVariables {
  input: CreateOrderInitializationInput;
}
