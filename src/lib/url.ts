import { Url } from '@friends-library/types';
import { Document, Friend } from '../build/types';

export function friendUrl(friend: Pick<Friend, 'gender' | 'slug' | 'lang'>): Url {
  if (friend.slug === `compilations`) {
    return `/compilations`;
  }

  if (friend.slug === `compilaciones`) {
    return `/compilaciones`;
  }

  if (friend.lang === `en`) {
    return `/friend/${friend.slug}`;
  }

  const pref = friend.gender == `male` ? `amigo` : `amiga`;
  return `/${pref}/${friend.slug}`;
}

export function documentUrl(
  document: Pick<Document, 'slug'>,
  friend: Pick<Friend, 'slug'>,
): Url {
  return `/${friend.slug}/${document.slug}`;
}
