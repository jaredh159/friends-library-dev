// auto-generated, do not edit

export namespace DocumentPage {
  export interface Input {
    lang: 'en' | 'es';
    friendSlug: string;
    documentSlug: string;
  }

  export interface Output {
    document: {
      authorName: string;
      authorSlug: string;
      authorGender: 'male' | 'female' | 'mixed';
      title: string;
      originalTitle?: string;
      isComplete: boolean;
      priceInCents: number;
      description: string;
      numDownloads: number;
      isCompilation: boolean;
      ogImageUrl: string;
      editions: Array<{
        type: 'updated' | 'original' | 'modernized';
        loggedDownloadUrls: {
          epub: string;
          mobi: string;
          pdf: string;
          speech: string;
        };
      }>;
      alternateLanguageDoc?: {
        authorSlug: string;
        slug: string;
      };
      primaryEdition: {
        editionType: 'updated' | 'original' | 'modernized';
        printSize: 's' | 'm' | 'xl';
        paperbackVolumes: [number, ...number[]];
        isbn: string;
        numChapters: number;
        audiobook?: {
          isIncomplete: boolean;
          numAudioParts: number;
          m4bFilesize: {
            lq: number;
            hq: number;
          };
          mp3ZipFilesize: {
            lq: number;
            hq: number;
          };
          m4bLoggedDownloadUrl: {
            lq: string;
            hq: string;
          };
          mp3ZipLoggedDownloadUrl: {
            lq: string;
            hq: string;
          };
          podcastLoggedDownloadUrl: {
            lq: string;
            hq: string;
          };
          embedId: {
            lq: number;
            hq: number;
          };
        };
      };
      customCss?: string;
      customCssUrl?: string;
    };
    otherBooksByAuthor: Array<{
      title: string;
      editionType: 'updated' | 'original' | 'modernized';
      description: string;
      paperbackVolumes: [number, ...number[]];
      isbn: string;
      audioDuration?: string;
      htmlShortTitle: string;
      documentSlug: string;
      createdAt: ISODateString;
    }>;
    numTotalBooks: number;
  }
}
