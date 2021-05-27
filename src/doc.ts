import { Uuid, ISBN, Sha, Url } from './primitive';
import { Lang, EditionType, Css, Html, Asciidoc, PrintSize } from '.';

export interface DocPrecursor {
  lang: Lang;
  friendSlug: string;
  friendInitials: string[];
  documentSlug: string;
  path: string;
  documentId: Uuid;
  isCompilation: boolean;
  editionType: EditionType;
  asciidocFiles: Array<{
    adoc: Asciidoc;
    filename: string;
  }>;
  paperbackSplits: number[];
  printSize?: PrintSize;
  blurb: string;
  config: { [key: string]: any };
  customCode: {
    css: { [k in ArtifactType | 'all' | 'pdf' | 'ebook']?: Css };
    html: { [k in ArtifactType | 'all' | 'pdf' | 'ebook']?: Html };
  };
  meta: {
    title: string;
    originalTitle?: string;
    published?: number;
    isbn: ISBN;
    editor?: string;
    author: {
      name: string;
      nameSort: string;
    };
  };
  revision: {
    timestamp: number;
    sha: Sha;
    url: Url;
  };
}

export function genericDpc(): DocPrecursor {
  return {
    lang: `en`,
    friendSlug: `george-fox`,
    friendInitials: [`G`, `F`],
    documentSlug: `journal`,
    path: `en/george-fox/journal/original`,
    documentId: `9414033c-4b70-4b4b-8e48-fec037822173`,
    isCompilation: false,
    editionType: `original`,
    asciidocFiles: [{ adoc: ``, filename: `01-journal.adoc` }],
    paperbackSplits: [],
    blurb: ``,
    config: {},
    customCode: { css: {}, html: {} },
    meta: {
      title: `Journal of George Fox`,
      isbn: `978-1-64476-029-1`,
      author: { name: `George Fox`, nameSort: `Fox, George` },
    },
    revision: { timestamp: 1611345625, sha: `327ceb2`, url: `` },
  };
}

export const ARTIFACT_TYPES = [
  `paperback-interior`,
  `paperback-cover`,
  `web-pdf`,
  `epub`,
  `mobi`,
  `speech`,
  `app-ebook`,
] as const;

export type ArtifactType = typeof ARTIFACT_TYPES[number];

export interface PaperbackInteriorConfig {
  printSize: PrintSize;
  frontmatter: boolean;
  condense: boolean;
  allowSplits: boolean;
}

export interface PaperbackCoverConfig {
  printSize: PrintSize;
  volumes: number[];
  showGuides?: boolean;
}

export interface EbookConfig {
  frontmatter: boolean;
  subType: 'epub' | 'mobi';
  coverImg?: Buffer;
  randomizeForLocalTesting?: boolean;
}
