import type { UpdateAudioInput, UpdateAudioPartInput } from '../../graphql/globalTypes';
import type { UpdateAudio, UpdateAudioVariables } from '../../graphql/UpdateAudio';
import type {
  UpdateAudioPart,
  UpdateAudioPartVariables,
} from '../../graphql/UpdateAudioPart';
import { logError } from '../../sub-log';
import client, { gql } from '../../api-client';

export async function updateAudio(input: UpdateAudioInput): Promise<void> {
  const variables: UpdateAudioVariables = { input };
  const { data } = await client.mutate<UpdateAudio>({
    mutation: UPDATE_AUDIO,
    variables,
  });
  if (!data) {
    logError(`Error updating audio, input=${input}`);
  }
}

export async function updateAudioPart(input: UpdateAudioPartInput): Promise<void> {
  const variables: UpdateAudioPartVariables = { input };
  const { data } = await client.mutate<UpdateAudioPart>({
    mutation: UPDATE_AUDIO_PART,
    variables,
  });
  if (!data) {
    logError(`Error updating audio part, input=${input}`);
  }
}

// operations

const UPDATE_AUDIO = gql`
  mutation UpdateAudio($input: UpdateAudioInput!) {
    audio: updateAudio(input: $input) {
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
