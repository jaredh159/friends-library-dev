import { type T } from '../../api-client';

export function friend(friend: T.EditableFriend): T.EditableFriend {
  friend.documents.forEach(document);
  friend.quotes.sort(byOrder);
  return friend;
}

export function document(doc: T.EditableDocument): T.EditableDocument {
  doc.editions.sort(({ type }) =>
    type === `updated` ? -1 : type === `modernized` ? -1 : 1,
  );
  doc.editions.forEach(edition);
  return doc;
}

export function edition(edition: T.EditableEdition): T.EditableEdition {
  edition.audio?.parts.sort(byOrder);
  return edition;
}

function byOrder<T extends { order: number }>(a: T, b: T): number {
  return a.order < b.order ? -1 : 1;
}
