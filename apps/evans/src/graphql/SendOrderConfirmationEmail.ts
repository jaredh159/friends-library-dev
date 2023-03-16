/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: SendOrderConfirmationEmail
// ====================================================

export interface SendOrderConfirmationEmail_response {
  __typename: 'GenericResponse';
  success: boolean;
}

export interface SendOrderConfirmationEmail {
  response: SendOrderConfirmationEmail_response;
}

export interface SendOrderConfirmationEmailVariables {
  id: string;
}
