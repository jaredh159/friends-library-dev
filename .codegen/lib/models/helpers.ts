export function modelDir(modelName: string): string {
  switch (modelName) {
    case `OrderItem`:
    case `FreeOrderRequest`:
      return `Orders/`;
    case `FriendQuote`:
    case `FriendResidence`:
      return `Friends/`;
    case `EditionChapter`:
    case `EditionImpression`:
      return `Editions/`;
    case `DocumentTag`:
    case `RelatedDocument`:
      return `Documents/`;
    case `AudioPart`:
      return `Audio/`;
    case `TokenScope`:
      return `Tokens/`;
    case `Isbn`:
      return ``;
    default:
      return `${modelName}s/`;
  }
}
