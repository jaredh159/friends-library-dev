// auto-generated, do not edit
import type { DocumentTag } from '../shared';

export namespace FriendPage {
  export interface Input {
    slug: string;
    lang: 'en' | 'es';
  }

  export interface Output {
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
        numPages: number[];
        size: 's' | 'm' | 'xl';
        type: 'updated' | 'original' | 'modernized';
      };
      editionTypes: Array<'updated' | 'original' | 'modernized'>;
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
  }
}
