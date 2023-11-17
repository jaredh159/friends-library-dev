import type { EditionType, Region } from './types';

// todo: logic is wrong, search old evans for 'james parnell case'
export function publishedYear(
  residenceDurations?: Array<{ start?: number; end?: number }>,
  authorBirthDate?: number,
  authorDeathDate?: number,
): number | null {
  const firstStay = residenceDurations?.[0];
  const publicationDate = firstStay ? firstStay.start ?? firstStay.end : null;
  return publicationDate ?? authorDeathDate ?? authorBirthDate ?? null;
}

export function documentRegion(document: {
  isCompilation: boolean;
  friendPrimaryResidence?: { region: string };
}): Region {
  if (document.isCompilation) {
    return `Other`;
  }
  const region = document.friendPrimaryResidence?.region;
  switch (region) {
    case `Ireland`:
      return `Ireland`;
    case `England`:
      return `England`;
    case `Scotland`:
      return `Scotland`;
    case `Wales`:
    case `Netherlands`:
    case `France`:
      return `Other`;
    case `Ohio`:
      return `Western US`;
    case `Delaware`:
    case `Pennsylvania`:
    case `New Jersey`:
    case `Rhode Island`:
    case `New York`:
    case `Vermont`:
      return `Eastern US`;
    default:
      throw new Error(`Error inferring explore region for friend: ${region}`);
  }
}

type SortableDoc = {
  primaryEdition: { type: EditionType };
  title: string;
};

export function sortDocuments(a: SortableDoc, b: SortableDoc): number {
  if (a.primaryEdition?.type !== b.primaryEdition?.type) {
    if (a.primaryEdition?.type === `updated`) {
      return -1;
    }
    if (a.primaryEdition?.type === `modernized`) {
      return b.primaryEdition?.type === `updated` ? 1 : -1;
    }
    return 1;
  }
  return a.title < b.title ? -1 : 1;
}
