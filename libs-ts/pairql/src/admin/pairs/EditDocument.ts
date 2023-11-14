// auto-generated, do not edit
import type { EditableDocument, SelectableDocument } from '../shared';

export namespace EditDocument {
  export type Input = UUID;

  export interface Output {
    document: EditableDocument;
    selectableDocuments: SelectableDocument[];
  }
}
