/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL query operation: GetFreeOrderRequest
// ====================================================

export interface GetFreeOrderRequest_request_address {
  __typename: 'ShippingAddress';
  name: string;
  street: string;
  street2: string | null;
  city: string;
  state: string;
  zip: string;
  country: string;
}

export interface GetFreeOrderRequest_request {
  __typename: 'FreeOrderRequest';
  email: string;
  address: GetFreeOrderRequest_request_address;
}

export interface GetFreeOrderRequest {
  request: GetFreeOrderRequest_request;
}

export interface GetFreeOrderRequestVariables {
  id: UUID;
}
