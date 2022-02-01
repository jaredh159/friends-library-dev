import { EditionType, PrintSize, Lang } from '@friends-library/types';
import { AdminOrderEditionResourceV1 } from '@friends-library/api';

export type Edition = AdminOrderEditionResourceV1 & { searchString: string };

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

// snowpack woes
