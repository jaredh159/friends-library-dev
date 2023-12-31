import { describe, it, expect } from 'vitest';
import type { Friend } from '../types';
import { sortDocuments, sortFriends } from '../query';

describe(`sortFriends()`, () => {
  it(`sorts residences by duration`, () => {
    const friend = {
      relatedDocuments: [],
      quotes: [],
      documents: [],
      residences: [
        {
          city: `Aberdeen`,
          region: `Scotland`,
          durations: [{ start: 1700, end: 1710 }],
        },
        {
          city: `London`,
          region: `England`,
          durations: [{ start: 1690, end: 1700 }],
        },
      ],
    } as Pick<Friend, 'residences' | 'quotes' | 'documents' | 'relatedDocuments'>;

    const sorted = sortFriends([friend as Friend]);
    expect(sorted[0].residences[0].durations[0].start).toBe(1690);
    expect(sorted[0].residences[1].durations[0].start).toBe(1700);
  });
});

describe(`sortDocuments()`, () => {
  let docs: Array<Parameters<typeof sortDocuments>[0]> = [];

  it(`prefers updated edition`, () => {
    docs = [
      { primaryEdition: { type: `original` }, title: `aaa` },
      { primaryEdition: { type: `updated` }, title: `zzz` },
    ];

    docs.sort(sortDocuments);

    expect(docs[0].title).toBe(`zzz`);
  });

  it(`sorts by title if editions equal`, () => {
    docs = [
      { primaryEdition: { type: `original` }, title: `zzz` },
      { primaryEdition: { type: `original` }, title: `aaa` },
    ];

    docs.sort(sortDocuments);

    expect(docs[0].title).toBe(`aaa`);
  });
});
