// auto-generated, do not edit

export interface EditableAudio {
  id: UUID;
  reader: string;
  isIncomplete: boolean;
  mp3ZipSizeHq: number;
  mp3ZipSizeLq: number;
  m4bSizeHq: number;
  m4bSizeLq: number;
  externalPlaylistIdHq?: number;
  externalPlaylistIdLq?: number;
  parts: EditableAudioPart[];
}

export interface EditableAudioPart {
  id: UUID;
  order: number;
  title: string;
  duration: number;
  chapters: number[];
  mp3SizeHq: number;
  mp3SizeLq: number;
  externalIdHq: number;
  externalIdLq: number;
}

export interface EditableDocument {
  id: UUID;
  altLanguageId?: UUID;
  title: string;
  slug: string;
  filename: string;
  published?: number;
  originalTitle?: string;
  incomplete: boolean;
  description: string;
  partialDescription: string;
  featuredDescription?: string;
  friend: { id: UUID; name: string; lang: 'en' | 'es' };
  editions: EditableEdition[];
  tags: Array<{
    id: UUID;
    type:
      | 'journal'
      | 'letters'
      | 'exhortation'
      | 'doctrinal'
      | 'treatise'
      | 'history'
      | 'allegory'
      | 'spiritualLife';
  }>;
  relatedDocuments: Array<{ id: UUID; description: string; parentDocumentId: UUID }>;
}

export interface EditableEdition {
  id: UUID;
  type: 'updated' | 'original' | 'modernized';
  paperbackSplits?: number[];
  paperbackOverrideSize?: 's' | 'm' | 'xl' | 'xlCondensed';
  editor?: string;
  isbn?: string;
  isDraft: boolean;
  audio?: EditableAudio;
}

export interface EditableFriend {
  id: UUID;
  lang: 'en' | 'es';
  name: string;
  slug: string;
  gender: 'male' | 'female' | 'mixed';
  born?: number;
  died?: number;
  description: string;
  published?: ISODateString;
  residences: EditableFriendResidence[];
  quotes: EditableFriendQuote[];
  documents: EditableDocument[];
}

export interface EditableFriendQuote {
  id: UUID;
  source: string;
  text: string;
  order: number;
}

export interface EditableFriendResidence {
  id: UUID;
  city: string;
  region: string;
  durations: Array<{ id: UUID; start: number; end: number }>;
}

export interface SelectableDocument {
  id: UUID;
  title: string;
  lang: 'en' | 'es';
  friendAlphabeticalName: string;
}
