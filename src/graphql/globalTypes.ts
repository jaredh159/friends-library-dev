/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

//==============================================================
// START Enums and Input Objects
//==============================================================

export enum EditionType {
  modernized = 'modernized',
  original = 'original',
  updated = 'updated',
}

export enum Gender {
  female = 'female',
  male = 'male',
  mixed = 'mixed',
}

export enum Lang {
  en = 'en',
  es = 'es',
}

export enum OrderSource {
  internal = 'internal',
  website = 'website',
}

export enum PrintJobStatus {
  accepted = 'accepted',
  bricked = 'bricked',
  canceled = 'canceled',
  pending = 'pending',
  presubmit = 'presubmit',
  rejected = 'rejected',
  shipped = 'shipped',
}

export enum PrintSize {
  m = 'm',
  s = 's',
  xl = 'xl',
}

export enum PrintSizeVariant {
  m = 'm',
  s = 's',
  xl = 'xl',
  xlCondensed = 'xlCondensed',
}

export enum Scope {
  all = 'all',
  mutateArtifactProductionVersions = 'mutateArtifactProductionVersions',
  mutateDownloads = 'mutateDownloads',
  mutateEntities = 'mutateEntities',
  mutateOrders = 'mutateOrders',
  mutateTokens = 'mutateTokens',
  queryArtifactProductionVersions = 'queryArtifactProductionVersions',
  queryDownloads = 'queryDownloads',
  queryEntities = 'queryEntities',
  queryOrders = 'queryOrders',
  queryTokens = 'queryTokens',
}

export enum ShippingLevel {
  expedited = 'expedited',
  express = 'express',
  ground = 'ground',
  groundBus = 'groundBus',
  groundHd = 'groundHd',
  mail = 'mail',
  priorityMail = 'priorityMail',
}

export enum TagType {
  allegory = 'allegory',
  doctrinal = 'doctrinal',
  exhortation = 'exhortation',
  history = 'history',
  journal = 'journal',
  letters = 'letters',
  spiritualLife = 'spiritualLife',
  treatise = 'treatise',
}

export interface CreateAudioInput {
  editionId: UUID;
  externalPlaylistIdHq?: Int64 | null;
  externalPlaylistIdLq?: Int64 | null;
  id?: UUID | null;
  isIncomplete: boolean;
  m4bSizeHq: number;
  m4bSizeLq: number;
  mp3ZipSizeHq: number;
  mp3ZipSizeLq: number;
  reader: string;
}

export interface CreateAudioPartInput {
  audioId: UUID;
  chapters: number[];
  duration: number;
  externalIdHq: Int64;
  externalIdLq: Int64;
  id?: UUID | null;
  mp3SizeHq: number;
  mp3SizeLq: number;
  order: number;
  title: string;
}

export interface CreateDocumentInput {
  altLanguageId?: UUID | null;
  description: string;
  featuredDescription?: string | null;
  filename: string;
  friendId: UUID;
  id?: UUID | null;
  incomplete: boolean;
  originalTitle?: string | null;
  partialDescription: string;
  published?: number | null;
  slug: string;
  title: string;
}

export interface CreateDocumentTagInput {
  documentId: UUID;
  id?: UUID | null;
  type: TagType;
}

export interface CreateEditionInput {
  documentId: UUID;
  editor?: string | null;
  id?: UUID | null;
  isDraft: boolean;
  paperbackOverrideSize?: PrintSizeVariant | null;
  paperbackSplits?: number[] | null;
  type: EditionType;
}

export interface CreateFriendInput {
  born?: number | null;
  description: string;
  died?: number | null;
  gender: Gender;
  id?: UUID | null;
  lang: Lang;
  name: string;
  published?: string | null;
  slug: string;
}

export interface CreateFriendQuoteInput {
  context?: string | null;
  friendId: UUID;
  id?: UUID | null;
  order: number;
  source: string;
  text: string;
}

export interface CreateFriendResidenceDurationInput {
  end: number;
  friendResidenceId: UUID;
  id?: UUID | null;
  start: number;
}

export interface CreateFriendResidenceInput {
  city: string;
  friendId: UUID;
  id?: UUID | null;
  region: string;
}

export interface CreateOrderInput {
  addressCity: string;
  addressCountry: string;
  addressName: string;
  addressState: string;
  addressStreet: string;
  addressStreet2?: string | null;
  addressZip: string;
  amount: number;
  ccFeeOffset: number;
  email: string;
  freeOrderRequestId?: UUID | null;
  id?: UUID | null;
  lang: Lang;
  paymentId: string;
  printJobId?: number | null;
  printJobStatus: PrintJobStatus;
  shipping: number;
  shippingLevel: ShippingLevel;
  source: OrderSource;
  taxes: number;
}

export interface CreateOrderItemInput {
  editionId: UUID;
  id?: UUID | null;
  orderId: UUID;
  quantity: number;
  unitPrice: number;
}

export interface CreateRelatedDocumentInput {
  description: string;
  documentId: UUID;
  id?: UUID | null;
  parentDocumentId: UUID;
}

export interface CreateTokenInput {
  description: string;
  id?: UUID | null;
  uses?: number | null;
  value: UUID;
}

export interface CreateTokenScopeInput {
  id?: UUID | null;
  scope: Scope;
  tokenId: UUID;
}

export interface GetPrintJobExploratoryMetadataInput {
  address: ShippingAddressInput;
  items: PrintJobExploratoryItemInput[];
}

export interface PrintJobExploratoryItemInput {
  printSize: PrintSize;
  quantity: number;
  volumes: number[];
}

export interface ShippingAddressInput {
  city: string;
  country: string;
  name: string;
  state: string;
  street: string;
  street2?: string | null;
  zip: string;
}

export interface UpdateAudioInput {
  editionId: UUID;
  externalPlaylistIdHq?: Int64 | null;
  externalPlaylistIdLq?: Int64 | null;
  id: UUID;
  isIncomplete: boolean;
  m4bSizeHq: number;
  m4bSizeLq: number;
  mp3ZipSizeHq: number;
  mp3ZipSizeLq: number;
  reader: string;
}

export interface UpdateAudioPartInput {
  audioId: UUID;
  chapters: number[];
  duration: number;
  externalIdHq: Int64;
  externalIdLq: Int64;
  id: UUID;
  mp3SizeHq: number;
  mp3SizeLq: number;
  order: number;
  title: string;
}

export interface UpdateDocumentInput {
  altLanguageId?: UUID | null;
  description: string;
  featuredDescription?: string | null;
  filename: string;
  friendId: UUID;
  id: UUID;
  incomplete: boolean;
  originalTitle?: string | null;
  partialDescription: string;
  published?: number | null;
  slug: string;
  title: string;
}

export interface UpdateDocumentTagInput {
  documentId: UUID;
  id: UUID;
  type: TagType;
}

export interface UpdateEditionInput {
  documentId: UUID;
  editor?: string | null;
  id: UUID;
  isDraft: boolean;
  paperbackOverrideSize?: PrintSizeVariant | null;
  paperbackSplits?: number[] | null;
  type: EditionType;
}

export interface UpdateFriendInput {
  born?: number | null;
  description: string;
  died?: number | null;
  gender: Gender;
  id: UUID;
  lang: Lang;
  name: string;
  published?: string | null;
  slug: string;
}

export interface UpdateFriendQuoteInput {
  context?: string | null;
  friendId: UUID;
  id: UUID;
  order: number;
  source: string;
  text: string;
}

export interface UpdateFriendResidenceDurationInput {
  end: number;
  friendResidenceId: UUID;
  id: UUID;
  start: number;
}

export interface UpdateFriendResidenceInput {
  city: string;
  friendId: UUID;
  id: UUID;
  region: string;
}

export interface UpdateRelatedDocumentInput {
  description: string;
  documentId: UUID;
  id: UUID;
  parentDocumentId: UUID;
}

export interface UpdateTokenInput {
  description: string;
  id: UUID;
  uses?: number | null;
  value: UUID;
}

export interface UpdateTokenScopeInput {
  id: UUID;
  scope: Scope;
  tokenId: UUID;
}

//==============================================================
// END Enums and Input Objects
//==============================================================
