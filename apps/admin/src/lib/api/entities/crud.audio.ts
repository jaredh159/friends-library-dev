import { gql } from '@apollo/client';
import client from '../../../client';
import { CreateAudio, CreateAudioVariables } from '../../../graphql/CreateAudio';
import { DeleteAudio } from '../../../graphql/DeleteAudio';
import { UpdateAudioInput } from '../../../graphql/globalTypes';
import { UpdateAudio, UpdateAudioVariables } from '../../../graphql/UpdateAudio';
import { EditableAudio, ErrorMsg } from '../../../types';
import { mutate, prepIds } from './helpers';

export async function create(audio: EditableAudio): Promise<ErrorMsg | null> {
  return mutate(`create`, audio, () =>
    client.mutate<CreateAudio, CreateAudioVariables>({
      mutation: CREATE_AUDIO,
      variables: { input: audioInput(audio) },
    }),
  );
}

export async function update(audio: EditableAudio): Promise<ErrorMsg | null> {
  return mutate(`update`, audio, () =>
    client.mutate<UpdateAudio, UpdateAudioVariables>({
      mutation: UPDATE_AUDIO,
      variables: { input: audioInput(audio) },
    }),
  );
}

async function remove(audio: EditableAudio): Promise<ErrorMsg | null> {
  return mutate(`delete`, audio, () =>
    client.mutate<DeleteAudio, IdentifyEntity>({
      mutation: DELETE_AUDIO,
      variables: prepIds({ id: audio.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_AUDIO = gql`
  mutation CreateAudio($input: CreateAudioInput!) {
    audio: createAudio(input: $input) {
      id
    }
  }
`;

const UPDATE_AUDIO = gql`
  mutation UpdateAudio($input: UpdateAudioInput!) {
    audio: updateAudio(input: $input) {
      id
    }
  }
`;

const DELETE_AUDIO = gql`
  mutation DeleteAudio($id: UUID!) {
    audio: deleteAudio(id: $id) {
      id
    }
  }
`;

// helpers

export function audioInput(audio: EditableAudio): UpdateAudioInput {
  return prepIds({
    id: audio.id,
    editionId: audio.edition.id,
    isIncomplete: audio.isIncomplete,
    reader: audio.reader,
    m4bSizeHq: audio.m4bSizeHq,
    mp3ZipSizeHq: audio.mp3ZipSizeHq,
    externalPlaylistIdHq: audio.externalPlaylistIdHq,
    m4bSizeLq: audio.m4bSizeLq,
    mp3ZipSizeLq: audio.mp3ZipSizeLq,
    externalPlaylistIdLq: audio.externalPlaylistIdLq,
  });
}
