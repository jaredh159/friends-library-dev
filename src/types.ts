import React from 'react';
import { PrintSize, Lang } from '@friends-library/types';
import { EditFriend as EditFriendQuery } from './graphql/EditFriend';
import { EditDocument as EditDocumentQuery } from './graphql/EditDocument';

export type Action<State> =
  | { type: `replace`; state: State }
  | { type: `add_item`; at: string; value: unknown }
  | { type: `delete_item`; at: string }
  | { type: `replace_value`; at: string; with: unknown }
  | { type: `update_year`; at: string; with: string };

export type Reducer<State> = React.Reducer<State, Action<State>>;

export type ReducerReplace = (
  path: string,
  preprocess?: (newValue: unknown) => unknown,
) => (value: unknown) => unknown;

export type OmitTypename<U> = Omit<U, '__typename'>;

export type EditableFriend = EditFriendQuery['friend'];
export type EditableFriendQuote = EditableFriend['quotes'][0];
export type EditableFriendResidence = EditableFriend['residences'][0];
export type EditableFriendResidenceDuration = EditableFriendResidence['durations'][0];
export type EditableDocument = EditDocumentQuery['document'];
export type EditableDocumentTag = EditableDocument['tags'][0];
export type EditableRelatedDocument = EditableDocument['relatedDocuments'][0];
export type EditableEdition = EditableDocument['editions'][0];

export type EditableEntity =
  | EditableFriend
  | EditableFriendQuote
  | EditableFriendResidence
  | EditableFriendResidenceDuration
  | EditableDocument
  | EditableDocumentTag
  | EditableRelatedDocument
  | EditableEdition;

export type SelectableDocuments = EditDocumentQuery['selectableDocuments'];

export type ReducerDeleteFrom = (path: string) => (index: number) => unknown;

export interface OrderItem {
  id: string;
  lang: Lang;
  displayTitle: string;
  orderTitle: string;
  author: string;
  image: string;
  editionId: string;
  unitPrice: number;
  quantity: number;
  printSize: PrintSize;
  pages: number[];
}

export interface OrderAddress {
  name: string;
  street: string;
  street2?: string | null;
  city: string;
  state: string;
  zip: string;
  country: string;
}
