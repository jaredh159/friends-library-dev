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

export interface FluidBgImageObject {
  aspectRatio: number;
  src: string;
  srcSet: string;
  sizes?: string;
  base64?: string;
  tracedSVG?: string;
  srcWebp?: string;
  srcSetWebp?: string;
  media?: string;
}

export interface FluidImageObject {
  aspectRatio: number;
  src: string;
  srcSet: string;
  sizes: string;
  base64?: string;
  tracedSVG?: string;
  srcWebp?: string;
  srcSetWebp?: string;
  media?: string;
}

export type NewsFeedType =
  | `book`
  | `audiobook`
  | `spanish_translation`
  | `feature`
  | `chapter`;
