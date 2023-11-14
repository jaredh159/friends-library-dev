// auto-generated, do not edit

export namespace GetFriends {
  export type Input = void;

  export type Output = Array<{
    id: UUID;
    lang: 'en' | 'es';
    slug: string;
    gender: 'male' | 'female' | 'mixed';
    name: string;
    born?: number;
    died?: number;
    description: string;
    isCompilations: boolean;
    published?: ISODateString;
    hasNonDraftDocument: boolean;
    primaryResidence?: {
      region: string;
      city: string;
    };
    documents: Array<{
      id: UUID;
      title: string;
      htmlTitle: string;
      htmlShortTitle: string;
      utf8ShortTitle: string;
      originalTitle?: string;
      slug: string;
      published?: number;
      incomplete: boolean;
      directoryPath: string;
      description: string;
      partialDescription: string;
      featuredDescription?: string;
      hasNonDraftEdition: boolean;
      tags: Array<
        | 'journal'
        | 'letters'
        | 'exhortation'
        | 'doctrinal'
        | 'treatise'
        | 'history'
        | 'allegory'
        | 'spiritualLife'
      >;
      altLanguageDocument?: {
        slug: string;
        htmlShortTitle: string;
        hasNonDraftEdition: boolean;
        friendSlug: string;
      };
      editions: Array<{
        id: UUID;
        type: 'updated' | 'original' | 'modernized';
        isDraft: boolean;
        path: string;
        numChapters: number;
        isbn?: string;
        podcastImageUrl: string;
        impression?: {
          paperbackPriceInCents: number;
          paperbackSize: 's' | 'm' | 'xl';
          paperbackVolumes: number[];
          ebookPdfLogUrl: string;
          ebookMobiLogUrl: string;
          ebookEpubLogUrl: string;
          ebookSpeechLogUrl: string;
          createdAt: ISODateString;
        };
        audio?: {
          reader: string;
          isPublished: boolean;
          isIncomplete: boolean;
          externalPlaylistIdHq?: number;
          externalPlaylistIdLq?: number;
          m4bSizeHq: number;
          m4bSizeLq: number;
          mp3ZipSizeHq: number;
          mp3ZipSizeLq: number;
          humanDurationClock: string;
          parts: Array<{
            title: string;
            isPublished: boolean;
            order: number;
            chapters: number[];
            duration: number;
            externalIdHq: number;
            externalIdLq: number;
            mp3SizeHq: number;
            mp3SizeLq: number;
            mp3FileLogUrlHq: string;
            mp3FileLogUrlLq: string;
          }>;
          m4bFileLogUrlHq: string;
          m4bFileLogUrlLq: string;
          mp3ZipFileLogUrlHq: string;
          mp3ZipFileLogUrlLq: string;
          podcastLogUrlHq: string;
          podcastLogUrlLq: string;
          podcastSourcePathHq: string;
          podcastSourcePathLq: string;
          createdAt: ISODateString;
        };
      }>;
      primaryEdition?: {
        id: UUID;
        type: 'updated' | 'original' | 'modernized';
        ogImageUrl: string;
      };
      relatedDocuments: Array<{
        description: string;
        documentId: UUID;
        documentHtmlShortTitle: string;
        documentDescription: string;
      }>;
    }>;
    relatedDocuments: Array<{
      description: string;
      documentId: UUID;
      documentHtmlShortTitle: string;
      documentDescription: string;
    }>;
    quotes: Array<{
      order: number;
      source: string;
      text: string;
    }>;
    residences: Array<{
      city: string;
      region: string;
      durations: Array<{
        start: number;
        end: number;
      }>;
    }>;
  }>;
}
