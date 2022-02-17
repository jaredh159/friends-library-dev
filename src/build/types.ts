import { Friends } from '../graphql/Friends';

export type Friend = Friends['friends'][0];
export type Document = Friend['documents'][0];
export type Edition = Document['editions'][0];
export type Audio = NonNullable<Edition['audio']>;
export type Impression = NonNullable<Edition['impression']>;
