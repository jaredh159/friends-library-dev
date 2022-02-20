import client, { gql } from '../../api-client';
import { PublishEdition, PublishEditionVariables } from '../../graphql/PublishEdition';
import { GetLatestArtifactProductionVersion } from '../../graphql/GetLatestArtifactProductionVersion';
import {
  CreateEditionChapterInput,
  CreateEditionImpressionInput,
} from '../../graphql/globalTypes';
import { CloudFiles, Edition } from './types';
import {
  UpdateEditionImpression,
  UpdateEditionImpressionVariables,
} from '../../graphql/UpdateEditionImpression';
import {
  CreateEditionImpression,
  CreateEditionImpressionVariables,
} from '../../graphql/CreateEditionImpression';
import {
  DeleteEditionImpression,
  DeleteEditionImpressionVariables,
} from '../../graphql/DeleteEditionImpression';
import {
  GetEditionImpressionCloudFiles,
  GetEditionImpressionCloudFilesVariables,
} from '../../graphql/GetEditionImpressionCloudFiles';
import {
  DeleteEditionEditionChapters,
  DeleteEditionEditionChaptersVariables,
} from '../../graphql/DeleteEditionEditionChapters';
import {
  CreateEditionChapters,
  CreateEditionChaptersVariables,
} from '../../graphql/CreateEditionChapters';

// edition impression crud

export async function saveEditionImpression(
  input: CreateEditionImpressionInput,
): Promise<UpdateEditionImpression> {
  let data: UpdateEditionImpression | null | undefined = undefined;
  if (input.id) {
    ({ data } = await client().mutate<
      UpdateEditionImpression,
      UpdateEditionImpressionVariables
    >({
      mutation: UPDATE_IMPRESSION_MUTATION,
      variables: { input: { ...input, id: input.id } },
    }));
  } else {
    ({ data } = await client().mutate<
      CreateEditionImpression,
      CreateEditionImpressionVariables
    >({
      mutation: CREATE_IMPRESSION_MUTATION,
      variables: { input },
    }));
  }
  if (!data) {
    throw new Error(`Failed to save EditionImpression`);
  }
  return data;
}

export async function deleteEditionImpression(id: UUID): Promise<boolean> {
  try {
    const { data } = await client().mutate<
      DeleteEditionImpression,
      DeleteEditionImpressionVariables
    >({ mutation: DELETE_IMPRESSION_MUTATION, variables: { id } });
    return !!data;
  } catch {
    return false;
  }
}

export async function getEditionImpressionCloudFiles(id: UUID): Promise<CloudFiles> {
  const { data } = await client().query<
    GetEditionImpressionCloudFiles,
    GetEditionImpressionCloudFilesVariables
  >({
    query: QUERY_IMPRESSION_FILES,
    variables: { id },
  });
  return data.impression.files;
}

const IMPRESSION_CLOUD_FILES_FIELDS = gql`
  fragment EditionImpressionCloudFiles on EditionImpression {
    files {
      paperback {
        cover {
          cloudPath: sourcePath
        }
        interior {
          cloudPath: sourcePath
        }
      }
      ebook {
        epub {
          cloudPath: sourcePath
        }
        mobi {
          cloudPath: sourcePath
        }
        pdf {
          cloudPath: sourcePath
        }
        speech {
          cloudPath: sourcePath
        }
        app {
          cloudPath: sourcePath
        }
      }
    }
  }
`;

const QUERY_IMPRESSION_FILES = gql`
  ${IMPRESSION_CLOUD_FILES_FIELDS}
  query GetEditionImpressionCloudFiles($id: UUID!) {
    impression: getEditionImpression(id: $id) {
      ...EditionImpressionCloudFiles
    }
  }
`;

const CREATE_IMPRESSION_MUTATION = gql`
  ${IMPRESSION_CLOUD_FILES_FIELDS}
  mutation CreateEditionImpression($input: CreateEditionImpressionInput!) {
    impression: createEditionImpression(input: $input) {
      ...EditionImpressionCloudFiles
    }
  }
`;

const UPDATE_IMPRESSION_MUTATION = gql`
  ${IMPRESSION_CLOUD_FILES_FIELDS}
  mutation UpdateEditionImpression($input: UpdateEditionImpressionInput!) {
    impression: updateEditionImpression(input: $input) {
      ...EditionImpressionCloudFiles
    }
  }
`;

const DELETE_IMPRESSION_MUTATION = gql`
  mutation DeleteEditionImpression($id: UUID!) {
    impression: deleteEditionImpression(id: $id) {
      id
    }
  }
`;

// edition chapter crud

export async function deleteEditionEditionChapters(editionId: UUID): Promise<boolean> {
  try {
    const { data } = await client().mutate<
      DeleteEditionEditionChapters,
      DeleteEditionEditionChaptersVariables
    >({
      mutation: DELETE_EDITION_EDITION_CHAPTERS_MUTATION,
      variables: { id: editionId },
    });
    return !!data;
  } catch {
    return false;
  }
}

export async function createEditionChapters(
  chapters: CreateEditionChapterInput[],
): Promise<boolean> {
  try {
    const { data } = await client().mutate<
      CreateEditionChapters,
      CreateEditionChaptersVariables
    >({
      mutation: CREATE_EDITION_CHAPTERS_MUTATION,
      variables: { input: chapters },
    });
    return !!data;
  } catch {
    return false;
  }
}

const DELETE_EDITION_EDITION_CHAPTERS_MUTATION = gql`
  mutation DeleteEditionEditionChapters($id: UUID!) {
    chapters: deleteEditionEditionChapters(id: $id) {
      id
    }
  }
`;

const CREATE_EDITION_CHAPTERS_MUTATION = gql`
  mutation CreateEditionChapters($input: [CreateEditionChapterInput!]!) {
    chapters: createEditionChapters(input: $input) {
      id
    }
  }
`;

// query individual edition

export async function getEdition(id: UUID): Promise<Edition> {
  const { data } = await client().query<PublishEdition, PublishEditionVariables>({
    query: EDITION_QUERY,
    variables: { id },
  });
  return data.edition;
}

const EDITION_QUERY = gql`
  query PublishEdition($id: UUID!) {
    edition: getEdition(id: $id) {
      isDraft
      images {
        square {
          all {
            width
            filename
            path
          }
        }
        threeD {
          all {
            width
            filename
            path
          }
        }
      }
      impression {
        id
        adocLength
        paperbackSizeVariant
        paperbackVolumes
        publishedRevision
        productionToolchainRevision
      }
      document {
        filename
      }
    }
  }
`;

// latest artifact production version

export async function getlatestArtifactProductionVersion(): Promise<string> {
  const { data } = await client().query<GetLatestArtifactProductionVersion>({
    query: REVISION_QUERY,
  });
  return data.version.sha;
}

const REVISION_QUERY = gql`
  query GetLatestArtifactProductionVersion {
    version: getLatestArtifactProductionVersion {
      sha: version
    }
  }
`;
