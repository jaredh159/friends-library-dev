import { gql } from '@apollo/client';
import client from '../../../client';
import { CreateDocument, CreateDocumentVariables } from '../../../graphql/CreateDocument';
import { DeleteDocument } from '../../../graphql/DeleteDocument';
import { UpdateDocumentInput } from '../../../graphql/globalTypes';
import { UpdateDocument, UpdateDocumentVariables } from '../../../graphql/UpdateDocument';
import { EditableDocument, ErrorMsg } from '../../../types';
import { mutate, nullEmptyString, prepIds } from './helpers';

export async function create(document: EditableDocument): Promise<ErrorMsg | null> {
  return mutate(`create`, document, () =>
    client.mutate<CreateDocument, CreateDocumentVariables>({
      mutation: CREATE_DOCUMENT,
      variables: { input: documentInput(document) },
    }),
  );
}

export async function update(document: EditableDocument): Promise<ErrorMsg | null> {
  return mutate(`update`, document, () =>
    client.mutate<UpdateDocument, UpdateDocumentVariables>({
      mutation: UPDATE_DOCUMENT,
      variables: { input: documentInput(document) },
    }),
  );
}

async function remove(document: EditableDocument): Promise<ErrorMsg | null> {
  return mutate(`delete`, document, () =>
    client.mutate<DeleteDocument, IdentifyEntity>({
      mutation: DELETE_DOCUMENT,
      variables: prepIds({ id: document.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_DOCUMENT = gql`
  mutation CreateDocument($input: CreateDocumentInput!) {
    document: createDocument(input: $input) {
      id
    }
  }
`;

const UPDATE_DOCUMENT = gql`
  mutation UpdateDocument($input: UpdateDocumentInput!) {
    document: updateDocument(input: $input) {
      id
    }
  }
`;

const DELETE_DOCUMENT = gql`
  mutation DeleteDocument($id: UUID!) {
    document: deleteDocument(id: $id) {
      id
    }
  }
`;

// helpers

export function documentInput(document: EditableDocument): UpdateDocumentInput {
  return prepIds({
    altLanguageId: nullEmptyString(document.altLanguageId),
    description: document.description,
    featuredDescription: nullEmptyString(document.featuredDescription),
    filename: document.filename,
    friendId: document.friend.id,
    id: document.id,
    incomplete: document.incomplete,
    originalTitle: nullEmptyString(document.originalTitle),
    partialDescription: document.partialDescription,
    published: document.published,
    slug: document.slug,
    title: document.title,
  });
}
