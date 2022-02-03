import { PrintSize, Lang } from '@friends-library/types';

export type ReducerReplace = (path: string) => (value: unknown) => unknown;
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
