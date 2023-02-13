import type {
  PublishEdition,
  PublishEditionVariables,
} from '../../graphql/PublishEdition';
import type { GetLatestArtifactProductionVersion } from '../../graphql/GetLatestArtifactProductionVersion';
import type {
  CreateEditionChapterInput,
  UpdateEditionImpressionInput,
} from '../../graphql/globalTypes';
import type {
  UpdateEditionImpression,
  UpdateEditionImpressionVariables,
} from '../../graphql/UpdateEditionImpression';
import type {
  CreateEditionImpression,
  CreateEditionImpressionVariables,
} from '../../graphql/CreateEditionImpression';
import type {
  DeleteEditionImpression,
  DeleteEditionImpressionVariables,
} from '../../graphql/DeleteEditionImpression';
import type {
  GetEditionImpressionCloudFiles,
  GetEditionImpressionCloudFilesVariables,
} from '../../graphql/GetEditionImpressionCloudFiles';
import type {
  DeleteEditionEditionChapters,
  DeleteEditionEditionChaptersVariables,
} from '../../graphql/DeleteEditionEditionChapters';
import type {
  CreateEditionChapters,
  CreateEditionChaptersVariables,
} from '../../graphql/CreateEditionChapters';
import type { CloudFiles, Edition } from './types';
import client, { gql } from '../../api-client';

// edition impression crud

export async function saveEditionImpression(
  current: UpdateEditionImpressionInput,
  previous: UpdateEditionImpressionInput | null,
): Promise<CloudFiles> {
  if (previous) {
    const { data } = await client.mutate<
      UpdateEditionImpression,
      UpdateEditionImpressionVariables
    >({
      mutation: UPDATE_IMPRESSION_MUTATION,
      variables: { input: { ...current, id: current.id } },
    });
    if (!data) {
      throw new Error(`Failed to update EditionImpression`);
    }
    return data.impression.files;
  } else {
    const { data } = await client.mutate<
      CreateEditionImpression,
      CreateEditionImpressionVariables
    >({
      mutation: CREATE_IMPRESSION_MUTATION,
      variables: { input: current },
    });
    if (!data) {
      throw new Error(`Failed to create EditionImpression`);
    }
    return getEditionImpressionCloudFiles(data.impression.id);
  }
}

export async function deleteEditionImpression(id: UUID): Promise<boolean> {
  try {
    const { data } = await client.mutate<
      DeleteEditionImpression,
      DeleteEditionImpressionVariables
    >({ mutation: DELETE_IMPRESSION_MUTATION, variables: { id } });
    return !!data;
  } catch {
    return false;
  }
}

export async function getEditionImpressionCloudFiles(id: UUID): Promise<CloudFiles> {
  const { data } = await client.query<
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
      id
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
    const { data } = await client.mutate<
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
    const { data } = await client.mutate<
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
  const { data } = await client.query<PublishEdition, PublishEditionVariables>({
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
  const { data } = await client.query<GetLatestArtifactProductionVersion>({
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
