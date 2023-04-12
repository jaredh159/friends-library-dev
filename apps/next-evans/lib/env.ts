import invariant from 'tiny-invariant';

invariant(process.env.NEXT_PUBLIC_LANG, `process.env.NEXT_PUBLIC_LANG is not defined`);

export const LANG = process.env.NEXT_PUBLIC_LANG === `es` ? `es` : `en`;
