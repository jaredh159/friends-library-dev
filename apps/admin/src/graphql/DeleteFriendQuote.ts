/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

// ====================================================
// GraphQL mutation operation: DeleteFriendQuote
// ====================================================

export interface DeleteFriendQuote_quote {
  __typename: 'FriendQuote';
  id: string;
}

export interface DeleteFriendQuote {
  quote: DeleteFriendQuote_quote;
}

export interface DeleteFriendQuoteVariables {
  id: UUID;
}
