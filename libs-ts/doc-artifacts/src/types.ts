export interface FileManifest {
  [key: string]: string | Buffer;
}

export interface Options {
  namespace?: string;
  srcPath?: string;
}

export type PdfOptions = Options & {
  formatOutput?: (line: string) => string;
};

export type EbookOptions = Options & {
  check: boolean;
};
