import { type T } from '@friends-library/pairql/evans-build';

export type Friend = T.GetFriends.Output[number];
export type FriendResidence = Friend['residences'][0];
export type Document = Friend['documents'][number];
export type Edition = Document['editions'][number];
export type Audio = NonNullable<Edition['audio']>;
export type AudioPart = Audio['parts'][number];
export type Impression = NonNullable<Edition['impression']>;

type LangCounts = { en: number; es: number };

export type PublishedCounts = {
  friends: LangCounts;
  books: LangCounts;
  updatedEditions: LangCounts;
  audioBooks: LangCounts;
};
