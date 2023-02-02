import type { EditableDocument, EditableEdition, EditableFriend } from '../../types';

export function friend(friend: EditableFriend): EditableFriend {
  friend.documents.forEach(document);
  friend.quotes.sort(byOrder);
  return friend;
}

export function document(doc: EditableDocument): EditableDocument {
  doc.editions.sort(({ type }) =>
    type === `updated` ? -1 : type === `modernized` ? -1 : 1,
  );
  doc.editions.forEach(edition);
  return doc;
}

export function edition(edition: EditableEdition): EditableEdition {
  edition.audio?.parts.sort(byOrder);
  return edition;
}

function byOrder<T extends { order: number }>(a: T, b: T): number {
  return a.order < b.order ? -1 : 1;
}
