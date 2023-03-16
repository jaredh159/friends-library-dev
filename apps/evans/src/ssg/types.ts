import type { Friends } from '../graphql/Friends';

export type Friend = Friends['friends'][0];
export type FriendResidence = Friend['residences'][0];
export type Document = Friend['documents'][0];
export type Edition = Document['editions'][0];
export type Audio = NonNullable<Edition['audio']>;
export type AudioPart = Audio['parts'][0];
export type Impression = NonNullable<Edition['impression']>;

type LangCounts = { en: number; es: number };

export type PublishedCounts = {
  friends: LangCounts;
  books: LangCounts;
  updatedEditions: LangCounts;
  audioBooks: LangCounts;
};
