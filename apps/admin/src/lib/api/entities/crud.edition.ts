import { gql } from '@apollo/client';
import client from '../../../client';
import { CreateEdition, CreateEditionVariables } from '../../../graphql/CreateEdition';
import { DeleteEdition } from '../../../graphql/DeleteEdition';
import { UpdateEditionInput } from '../../../graphql/globalTypes';
import { UpdateEdition, UpdateEditionVariables } from '../../../graphql/UpdateEdition';
import { EditableEdition, ErrorMsg } from '../../../types';
import { mutate, nullEmptyString, prepIds } from './helpers';

export async function create(edition: EditableEdition): Promise<ErrorMsg | null> {
  return mutate(`create`, edition, () =>
    client.mutate<CreateEdition, CreateEditionVariables>({
      mutation: CREATE_EDITION,
      variables: { input: editionInput(edition) },
    }),
  );
}

export async function update(edition: EditableEdition): Promise<ErrorMsg | null> {
  return mutate(`update`, edition, () =>
    client.mutate<UpdateEdition, UpdateEditionVariables>({
      mutation: UPDATE_EDITION,
      variables: { input: editionInput(edition) },
    }),
  );
}

async function remove(edition: EditableEdition): Promise<ErrorMsg | null> {
  return mutate(`delete`, edition, () =>
    client.mutate<DeleteEdition, IdentifyEntity>({
      mutation: DELETE_EDITION,
      variables: prepIds({ id: edition.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_EDITION = gql`
  mutation CreateEdition($input: CreateEditionInput!) {
    edition: createEdition(input: $input) {
      id
    }
  }
`;

const UPDATE_EDITION = gql`
  mutation UpdateEdition($input: UpdateEditionInput!) {
    edition: updateEdition(input: $input) {
      id
    }
  }
`;

const DELETE_EDITION = gql`
  mutation DeleteEdition($id: UUID!) {
    edition: deleteEdition(id: $id) {
      id
    }
  }
`;

// helpers

export function editionInput(edition: EditableEdition): UpdateEditionInput {
  return prepIds({
    id: edition.id,
    documentId: edition.document.id,
    isDraft: edition.isDraft,
    type: edition.type,
    editor: nullEmptyString(edition.editor),
    paperbackOverrideSize: edition.paperbackOverrideSize,
    paperbackSplits: edition.paperbackSplits,
  });
}
