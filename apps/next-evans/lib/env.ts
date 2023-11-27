import invariant from 'tiny-invariant';

invariant(process.env.NEXT_PUBLIC_LANG, `process.env.NEXT_PUBLIC_LANG is not defined`);

export const LANG = process.env.NEXT_PUBLIC_LANG === `es` ? `es` : `en`;

export const APP_URL: string = (() => {
  if (process.env.NODE_ENV === `development`) {
    return `http://localhost:${LANG === `en` ? 7222 : 7333}`;
  }

  // @TODO: we might possibly be able to determine vercel
  // deployment urls in preview/production environments
  return LANG === `en`
    ? `https://www.friendslibrary.com`
    : `https://www.bibliotecadelosamigos.org`;
})();

export const APP_ALT_URL: string = (() => {
  if (process.env.NODE_ENV === `development`) {
    return `http://localhost:${LANG === `en` ? 7333 : 7222}`;
  }

  // @TODO: we might possibly be able to determine vercel
  // deployment urls in preview/production environments
  return LANG === `en`
    ? `https://www.bibliotecadelosamigos.org`
    : `https://www.friendslibrary.com`;
})();
