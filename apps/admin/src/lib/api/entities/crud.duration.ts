import { gql } from '@apollo/client';
import type {
  CreateFriendResidenceDuration,
  CreateFriendResidenceDurationVariables,
} from '../../../graphql/CreateFriendResidenceDuration';
import type { DeleteFriendResidenceDuration } from '../../../graphql/DeleteFriendResidenceDuration';
import type { UpdateFriendResidenceDurationInput } from '../../../graphql/globalTypes';
import type {
  UpdateFriendResidenceDuration,
  UpdateFriendResidenceDurationVariables,
} from '../../../graphql/UpdateFriendResidenceDuration';
import type { EditableFriendResidenceDuration, ErrorMsg } from '../../../types';
import client from '../../../client';
import { mutate, prepIds } from './helpers';

export async function create(
  duration: EditableFriendResidenceDuration,
): Promise<ErrorMsg | null> {
  return mutate(`create`, duration, () =>
    client.mutate<CreateFriendResidenceDuration, CreateFriendResidenceDurationVariables>({
      mutation: CREATE_DURATION,
      variables: { input: durationInput(duration) },
    }),
  );
}

export async function update(
  duration: EditableFriendResidenceDuration,
): Promise<ErrorMsg | null> {
  return mutate(`update`, duration, () =>
    client.mutate<UpdateFriendResidenceDuration, UpdateFriendResidenceDurationVariables>({
      mutation: UPDATE_DURATION,
      variables: { input: durationInput(duration) },
    }),
  );
}

async function remove(
  duration: EditableFriendResidenceDuration,
): Promise<ErrorMsg | null> {
  return mutate(`delete`, duration, () =>
    client.mutate<DeleteFriendResidenceDuration, IdentifyEntity>({
      mutation: DELETE_DURATION,
      variables: prepIds({ id: duration.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_DURATION = gql`
  mutation CreateFriendResidenceDuration($input: CreateFriendResidenceDurationInput!) {
    duration: createFriendResidenceDuration(input: $input) {
      id
    }
  }
`;

const UPDATE_DURATION = gql`
  mutation UpdateFriendResidenceDuration($input: UpdateFriendResidenceDurationInput!) {
    duration: updateFriendResidenceDuration(input: $input) {
      id
    }
  }
`;

const DELETE_DURATION = gql`
  mutation DeleteFriendResidenceDuration($id: UUID!) {
    duration: deleteFriendResidenceDuration(id: $id) {
      id
    }
  }
`;

// helpers

export function durationInput(
  duration: EditableFriendResidenceDuration,
): UpdateFriendResidenceDurationInput {
  return prepIds({
    id: duration.id,
    friendResidenceId: duration.residence.id,
    start: duration.start,
    end: duration.end,
  });
}
