// auto-generated, do not edit

export namespace HomepageFeaturedBooks {
  export interface Input {
    lang: 'en' | 'es';
    slugs: Array<{
      friendSlug: string;
      documentSlug: string;
    }>;
  }

  export type Output = Array<{
    isbn: string;
    title: string;
    paperbackVolumes: [number, ...number[]];
    customCss?: string;
    customHtml?: string;
    isCompilation: boolean;
    authorName: string;
    authorSlug: string;
    authorGender: 'male' | 'female' | 'mixed';
    documentSlug: string;
    featuredDescription: string;
  }>;
}
