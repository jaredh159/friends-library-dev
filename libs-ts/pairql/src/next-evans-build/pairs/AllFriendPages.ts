// auto-generated, do not edit
import type { DocumentTag } from '../shared';

export namespace AllFriendPages {
  export type Input = 'en' | 'es';

  export type Output = {
    [key: string]: {
      born?: number;
      died?: number;
      name: string;
      slug: string;
      description: string;
      gender: 'male' | 'female' | 'mixed';
      isCompilations: boolean;
      documents: Array<{
        id: UUID;
        title: string;
        htmlShortTitle: string;
        shortDescription: string;
        slug: string;
        numDownloads: number;
        tags: DocumentTag[];
        hasAudio: boolean;
        primaryEdition: {
          isbn: string;
          numPages: [number, ...number[]];
          size: 's' | 'm' | 'xl';
          type: 'updated' | 'original' | 'modernized';
        };
        editionTypes: Array<'updated' | 'original' | 'modernized'>;
        customCss?: string;
        customHtml?: string;
      }>;
      residences: Array<{
        city: string;
        region: string;
        durations: Array<{
          start: number;
          end: number;
        }>;
      }>;
      quotes: Array<{
        text: string;
        source: string;
      }>;
    };
  };
}
