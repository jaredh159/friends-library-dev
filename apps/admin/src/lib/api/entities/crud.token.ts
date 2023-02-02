import client, { gql } from '../../../client';
import { CreateToken, CreateTokenVariables } from '../../../graphql/CreateToken';
import { DeleteToken } from '../../../graphql/DeleteToken';
import { UpdateTokenInput } from '../../../graphql/globalTypes';
import { UpdateToken, UpdateTokenVariables } from '../../../graphql/UpdateToken';
import { EditableToken, ErrorMsg } from '../../../types';
import { mutate, prepIds } from './helpers';

export async function create(part: EditableToken): Promise<ErrorMsg | null> {
  return mutate(`create`, part, () =>
    client.mutate<CreateToken, CreateTokenVariables>({
      mutation: CREATE_TOKEN,
      variables: { input: tokenInput(part) },
    }),
  );
}

export async function update(part: EditableToken): Promise<ErrorMsg | null> {
  return mutate(`update`, part, () =>
    client.mutate<UpdateToken, UpdateTokenVariables>({
      mutation: UPDATE_TOKEN,
      variables: { input: tokenInput(part) },
    }),
  );
}

async function remove(part: EditableToken): Promise<ErrorMsg | null> {
  return mutate(`delete`, part, () =>
    client.mutate<DeleteToken, IdentifyEntity>({
      mutation: DELETE_TOKEN,
      variables: prepIds({ id: part.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_TOKEN = gql`
  mutation CreateToken($input: CreateTokenInput!) {
    part: createToken(input: $input) {
      id
    }
  }
`;

const UPDATE_TOKEN = gql`
  mutation UpdateToken($input: UpdateTokenInput!) {
    part: updateToken(input: $input) {
      id
    }
  }
`;

const DELETE_TOKEN = gql`
  mutation DeleteToken($id: UUID!) {
    part: deleteToken(id: $id) {
      id
    }
  }
`;

// helpers

export function tokenInput(token: EditableToken): UpdateTokenInput {
  return prepIds({
    id: token.id,
    description: token.description,
    value: token.value,
  });
}
