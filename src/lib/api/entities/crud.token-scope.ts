import client, { gql } from '../../../client';
import {
  CreateTokenScope,
  CreateTokenScopeVariables,
} from '../../../graphql/CreateTokenScope';
import { DeleteTokenScope } from '../../../graphql/DeleteTokenScope';
import { UpdateTokenScopeInput } from '../../../graphql/globalTypes';
import {
  UpdateTokenScope,
  UpdateTokenScopeVariables,
} from '../../../graphql/UpdateTokenScope';
import { EditableTokenScope, ErrorMsg } from '../../../types';
import { mutate, prepIds } from './helpers';

export async function create(part: EditableTokenScope): Promise<ErrorMsg | null> {
  return mutate(`create`, part, () =>
    client.mutate<CreateTokenScope, CreateTokenScopeVariables>({
      mutation: CREATE_TOKEN_SCOPE,
      variables: { input: tokenScopeInput(part) },
    }),
  );
}

export async function update(part: EditableTokenScope): Promise<ErrorMsg | null> {
  return mutate(`update`, part, () =>
    client.mutate<UpdateTokenScope, UpdateTokenScopeVariables>({
      mutation: UPDATE_TOKEN_SCOPE,
      variables: { input: tokenScopeInput(part) },
    }),
  );
}

async function remove(part: EditableTokenScope): Promise<ErrorMsg | null> {
  return mutate(`delete`, part, () =>
    client.mutate<DeleteTokenScope, IdentifyEntity>({
      mutation: DELETE_TOKEN_SCOPE,
      variables: prepIds({ id: part.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_TOKEN_SCOPE = gql`
  mutation CreateTokenScope($input: CreateTokenScopeInput!) {
    part: createTokenScope(input: $input) {
      id
    }
  }
`;

const UPDATE_TOKEN_SCOPE = gql`
  mutation UpdateTokenScope($input: UpdateTokenScopeInput!) {
    part: updateTokenScope(input: $input) {
      id
    }
  }
`;

const DELETE_TOKEN_SCOPE = gql`
  mutation DeleteTokenScope($id: UUID!) {
    part: deleteTokenScope(id: $id) {
      id
    }
  }
`;

// helpers

export function tokenScopeInput(tokenScope: EditableTokenScope): UpdateTokenScopeInput {
  return prepIds({
    id: tokenScope.id,
    tokenId: tokenScope.token.id,
    scope: tokenScope.type,
  });
}
