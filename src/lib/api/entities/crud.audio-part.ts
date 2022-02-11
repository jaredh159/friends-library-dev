import { gql } from '@apollo/client';
import client from '../../../client';
import {
  CreateAudioPart,
  CreateAudioPartVariables,
} from '../../../graphql/CreateAudioPart';
import { DeleteAudioPart } from '../../../graphql/DeleteAudioPart';
import { UpdateAudioPartInput } from '../../../graphql/globalTypes';
import {
  UpdateAudioPart,
  UpdateAudioPartVariables,
} from '../../../graphql/UpdateAudioPart';
import { EditableAudioPart, ErrorMsg } from '../../../types';
import { mutate, prepIds } from './helpers';

export async function create(part: EditableAudioPart): Promise<ErrorMsg | null> {
  return mutate(`create`, part, () =>
    client.mutate<CreateAudioPart, CreateAudioPartVariables>({
      mutation: CREATE_AUDIO_PART,
      variables: { input: audioInput(part) },
    }),
  );
}

export async function update(part: EditableAudioPart): Promise<ErrorMsg | null> {
  return mutate(`update`, part, () =>
    client.mutate<UpdateAudioPart, UpdateAudioPartVariables>({
      mutation: UPDATE_AUDIO_PART,
      variables: { input: audioInput(part) },
    }),
  );
}

async function remove(part: EditableAudioPart): Promise<ErrorMsg | null> {
  return mutate(`delete`, part, () =>
    client.mutate<DeleteAudioPart, IdentifyEntity>({
      mutation: DELETE_AUDIO_PART,
      variables: prepIds({ id: part.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_AUDIO_PART = gql`
  mutation CreateAudioPart($input: CreateAudioPartInput!) {
    part: createAudioPart(input: $input) {
      id
    }
  }
`;

const UPDATE_AUDIO_PART = gql`
  mutation UpdateAudioPart($input: UpdateAudioPartInput!) {
    part: updateAudioPart(input: $input) {
      id
    }
  }
`;

const DELETE_AUDIO_PART = gql`
  mutation DeleteAudioPart($id: UUID!) {
    part: deleteAudioPart(id: $id) {
      id
    }
  }
`;

// helpers

export function audioInput(part: EditableAudioPart): UpdateAudioPartInput {
  return prepIds({
    id: part.id,
    order: part.order,
    title: part.title,
    audioId: part.audio.id,
    chapters: part.chapters,
    duration: part.duration,
    externalIdHq: part.externalIdHq,
    mp3SizeHq: part.mp3SizeHq,
    externalIdLq: part.externalIdLq,
    mp3SizeLq: part.mp3SizeLq,
  });
}
