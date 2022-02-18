declare module '*.jpg';
declare module '*.png';

export interface NumPublishedBooks {
  numPublished: {
    books: { en: number; es: number };
  };
}

export interface Address {
  name: string;
  street: string;
  street2?: string;
  city: string;
  state: string;
  zip: string;
  country: string;
  unusable?: boolean;
}

export type AddressWithEmail = Address & { email: string };
