export default class Model {
  public name: string;
  public filepath: string;
  public migrationNumber?: number;
  public taggedTypes: Record<string, string> = {};
  public dbEnums: Record<string, string[]> = {};
  public relations: Record<string, { type: string; relationType: string }> = {};
  public props: Array<{ name: string; type: string }> = [];
  public init: Array<{ propName: string; hasDefault: boolean }> = [];

  public constructor(name: string = ``, filepath: string = ``) {
    this.name = name;
    this.filepath = filepath;
  }

  public get dir(): string {
    return `Sources/App/Models${modelDir(this.name)}`;
  }

  public get camelCaseName(): string {
    return this.name.charAt(0).toLowerCase() + this.name.slice(1);
  }

  public static mock(): Model {
    return new Model(`Thing`, `Sources/App/Models/Things/Thing.swift`);
  }
}

// helpers

function modelDir(modelName: string): string {
  switch (modelName) {
    case `OrderItem`:
    case `FreeOrderRequest`:
      return `/Orders`;
    case `FriendQuote`:
    case `FriendResidence`:
    case `FriendResidenceDuration`:
      return `/Friends`;
    case `EditionChapter`:
    case `EditionImpression`:
      return `/Editions`;
    case `DocumentTag`:
    case `RelatedDocument`:
      return `/Documents`;
    case `AudioPart`:
      return `/Audios`;
    case `TokenScope`:
      return `/Tokens`;
    case `Isbn`:
      return ``;
    default:
      return `/${modelName}s`;
  }
}
