import { gql } from '@apollo/client';
import client from '../../../client';
import {
  CreateDocumentTag,
  CreateDocumentTagVariables,
} from '../../../graphql/CreateDocumentTag';
import { DeleteDocumentTag } from '../../../graphql/DeleteDocumentTag';
import { UpdateDocumentTagInput } from '../../../graphql/globalTypes';
import {
  UpdateDocumentTag,
  UpdateDocumentTagVariables,
} from '../../../graphql/UpdateDocumentTag';
import { EditableDocumentTag, ErrorMsg } from '../../../types';
import { mutate, prepIds } from './helpers';

export async function create(tag: EditableDocumentTag): Promise<ErrorMsg | null> {
  return mutate(`create`, tag, () =>
    client.mutate<CreateDocumentTag, CreateDocumentTagVariables>({
      mutation: CREATE_TAG,
      variables: { input: tagInput(tag) },
    }),
  );
}

export async function update(tag: EditableDocumentTag): Promise<ErrorMsg | null> {
  return mutate(`update`, tag, () =>
    client.mutate<UpdateDocumentTag, UpdateDocumentTagVariables>({
      mutation: UPDATE_TAG,
      variables: { input: tagInput(tag) },
    }),
  );
}

async function remove(tag: EditableDocumentTag): Promise<ErrorMsg | null> {
  return mutate(`delete`, tag, () =>
    client.mutate<DeleteDocumentTag, IdentifyEntity>({
      mutation: DELETE_TAG,
      variables: prepIds({ id: tag.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_TAG = gql`
  mutation CreateDocumentTag($input: CreateDocumentTagInput!) {
    tag: createDocumentTag(input: $input) {
      id
    }
  }
`;

const UPDATE_TAG = gql`
  mutation UpdateDocumentTag($input: UpdateDocumentTagInput!) {
    tag: updateDocumentTag(input: $input) {
      id
    }
  }
`;

const DELETE_TAG = gql`
  mutation DeleteDocumentTag($id: UUID!) {
    tag: deleteDocumentTag(id: $id) {
      id
    }
  }
`;

// helpers

export function tagInput(tag: EditableDocumentTag): UpdateDocumentTagInput {
  return prepIds({
    id: tag.id,
    documentId: tag.document.id,
    type: tag.type,
  });
}
