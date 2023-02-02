import { gql } from '@apollo/client';
import type {
  CreateFriendResidence,
  CreateFriendResidenceVariables,
} from '../../../graphql/CreateFriendResidence';
import type { DeleteFriendResidence } from '../../../graphql/DeleteFriendResidence';
import type { UpdateFriendResidenceInput } from '../../../graphql/globalTypes';
import type {
  UpdateFriendResidence,
  UpdateFriendResidenceVariables,
} from '../../../graphql/UpdateFriendResidence';
import type { EditableFriendResidence, ErrorMsg } from '../../../types';
import client from '../../../client';
import { mutate, prepIds } from './helpers';

export async function create(
  residence: EditableFriendResidence,
): Promise<ErrorMsg | null> {
  return mutate(`create`, residence, () =>
    client.mutate<CreateFriendResidence, CreateFriendResidenceVariables>({
      mutation: CREATE_RESIDENCE,
      variables: { input: residenceInput(residence) },
    }),
  );
}

export async function update(
  residence: EditableFriendResidence,
): Promise<ErrorMsg | null> {
  return mutate(`update`, residence, () =>
    client.mutate<UpdateFriendResidence, UpdateFriendResidenceVariables>({
      mutation: UPDATE_RESIDENCE,
      variables: { input: residenceInput(residence) },
    }),
  );
}

async function remove(residence: EditableFriendResidence): Promise<ErrorMsg | null> {
  return mutate(`delete`, residence, () =>
    client.mutate<DeleteFriendResidence, IdentifyEntity>({
      mutation: DELETE_RESIDENCE,
      variables: prepIds({ id: residence.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_RESIDENCE = gql`
  mutation CreateFriendResidence($input: CreateFriendResidenceInput!) {
    residence: createFriendResidence(input: $input) {
      id
    }
  }
`;

const UPDATE_RESIDENCE = gql`
  mutation UpdateFriendResidence($input: UpdateFriendResidenceInput!) {
    residence: updateFriendResidence(input: $input) {
      id
    }
  }
`;

const DELETE_RESIDENCE = gql`
  mutation DeleteFriendResidence($id: UUID!) {
    residence: deleteFriendResidence(id: $id) {
      id
    }
  }
`;

// helpers

export function residenceInput(
  residence: EditableFriendResidence,
): UpdateFriendResidenceInput {
  return prepIds({
    id: residence.id,
    friendId: residence.friend.id,
    city: residence.city,
    region: residence.region,
  });
}
