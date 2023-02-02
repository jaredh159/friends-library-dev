import { gql } from '@apollo/client';
import type {
  CreateRelatedDocument,
  CreateRelatedDocumentVariables,
} from '../../../graphql/CreateRelatedDocument';
import type { DeleteRelatedDocument } from '../../../graphql/DeleteRelatedDocument';
import type { UpdateRelatedDocumentInput } from '../../../graphql/globalTypes';
import type {
  UpdateRelatedDocument,
  UpdateRelatedDocumentVariables,
} from '../../../graphql/UpdateRelatedDocument';
import type { EditableRelatedDocument, ErrorMsg } from '../../../types';
import client from '../../../client';
import { mutate, prepIds } from './helpers';

export async function create(
  relatedDocument: EditableRelatedDocument,
): Promise<ErrorMsg | null> {
  return mutate(`create`, relatedDocument, () =>
    client.mutate<CreateRelatedDocument, CreateRelatedDocumentVariables>({
      mutation: CREATE_RELATED_DOCUMENT,
      variables: { input: relatedDocumentInput(relatedDocument) },
    }),
  );
}

export async function update(
  relatedDocument: EditableRelatedDocument,
): Promise<ErrorMsg | null> {
  return mutate(`update`, relatedDocument, () =>
    client.mutate<UpdateRelatedDocument, UpdateRelatedDocumentVariables>({
      mutation: UPDATE_RELATED_DOCUMENT,
      variables: { input: relatedDocumentInput(relatedDocument) },
    }),
  );
}

async function remove(
  relatedDocument: EditableRelatedDocument,
): Promise<ErrorMsg | null> {
  return mutate(`delete`, relatedDocument, () =>
    client.mutate<DeleteRelatedDocument, IdentifyEntity>({
      mutation: DELETE_RELATED_DOCUMENT,
      variables: prepIds({ id: relatedDocument.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_RELATED_DOCUMENT = gql`
  mutation CreateRelatedDocument($input: CreateRelatedDocumentInput!) {
    relatedDocument: createRelatedDocument(input: $input) {
      id
    }
  }
`;

const UPDATE_RELATED_DOCUMENT = gql`
  mutation UpdateRelatedDocument($input: UpdateRelatedDocumentInput!) {
    relatedDocument: updateRelatedDocument(input: $input) {
      id
    }
  }
`;

const DELETE_RELATED_DOCUMENT = gql`
  mutation DeleteRelatedDocument($id: UUID!) {
    relatedDocument: deleteRelatedDocument(id: $id) {
      id
    }
  }
`;

// helpers

export function relatedDocumentInput(
  relatedDocument: EditableRelatedDocument,
): UpdateRelatedDocumentInput {
  return prepIds({
    id: relatedDocument.id,
    description: relatedDocument.description,
    documentId: relatedDocument.document.id,
    parentDocumentId: relatedDocument.parentDocument.id,
  });
}
