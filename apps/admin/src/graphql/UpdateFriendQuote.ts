/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { UpdateFriendQuoteInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: UpdateFriendQuote
// ====================================================

export interface UpdateFriendQuote_quote {
  __typename: 'FriendQuote';
  id: string;
}

export interface UpdateFriendQuote {
  quote: UpdateFriendQuote_quote;
}

export interface UpdateFriendQuoteVariables {
  input: UpdateFriendQuoteInput;
}
