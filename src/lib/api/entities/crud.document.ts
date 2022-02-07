import { gql } from '@apollo/client';
import client from '../../../client';
import { CreateDocument, CreateDocumentVariables } from '../../../graphql/CreateDocument';
import { UpdateDocumentInput } from '../../../graphql/globalTypes';
import { UpdateDocument, UpdateDocumentVariables } from '../../../graphql/UpdateDocument';
import { EditableDocument, ErrorMsg } from '../../../types';
import { mutate } from './helpers';

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

// helpers

export function documentInput(document: EditableDocument): UpdateDocumentInput {
  return {
    altLanguageId: document.altLanguageId,
    description: document.description,
    featuredDescription: document.featuredDescription,
    filename: document.filename,
    friendId: document.friend.id.replace(/^_/, ``),
    id: document.id.replace(/^_/, ``),
    incomplete: document.incomplete,
    originalTitle: document.originalTitle,
    partialDescription: document.partialDescription,
    published: document.published,
    slug: document.slug,
    title: document.title,
  };
}
