import { Audio } from './types';
import { GetAudios } from '../../graphql/GetAudios';
import { UpdateAudioInput, UpdateAudioPartInput } from '../../graphql/globalTypes';
import { UpdateAudio, UpdateAudioVariables } from '../../graphql/UpdateAudio';
import { logError } from '../../sub-log';
import { UpdateAudioPart, UpdateAudioPartVariables } from '../../graphql/UpdateAudioPart';
import client, { gql } from '../../api-client';

export async function getAudios(): Promise<Audio[]> {
  const { data } = await client().query<GetAudios>({ query: QUERY_AUDIOS });
  return data.audios;
}

export async function updateAudio(input: UpdateAudioInput): Promise<void> {
  const variables: UpdateAudioVariables = { input };
  const { data } = await client().mutate<UpdateAudio>({
    mutation: UPDATE_AUDIO,
    variables,
  });
  if (!data) {
    logError(`Error updating audio, input=${input}`);
  }
}

export async function updateAudioPart(input: UpdateAudioPartInput): Promise<void> {
  const variables: UpdateAudioPartVariables = { input };
  const { data } = await client().mutate<UpdateAudioPart>({
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

const QUERY_AUDIOS = gql`
  query GetAudios {
    audios: getAudios {
      id
      isIncomplete
      m4bSizeHq
      m4bSizeLq
      mp3ZipSizeHq
      mp3ZipSizeLq
      reader
      externalPlaylistIdHq
      externalPlaylistIdLq
      parts {
        id
        chapters
        duration
        title
        order
        externalIdHq
        externalIdLq
        mp3SizeHq
        mp3SizeLq
      }
      edition {
        id
        path: directoryPath
        type
        images {
          square {
            w1400 {
              path
            }
          }
        }
        document {
          filename
          title
          slug
          description
          path: directoryPath
          tags {
            type
          }
          friend {
            lang
            name
            slug
            alphabeticalName
            isCompilations
          }
        }
      }
    }
  }
`;
