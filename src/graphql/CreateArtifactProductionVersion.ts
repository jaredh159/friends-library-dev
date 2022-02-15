/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { CreateArtifactProductionVersionInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: CreateArtifactProductionVersion
// ====================================================

export interface CreateArtifactProductionVersion_created {
  __typename: 'ArtifactProductionVersion';
  version: string;
}

export interface CreateArtifactProductionVersion {
  created: CreateArtifactProductionVersion_created;
}

export interface CreateArtifactProductionVersionVariables {
  input: CreateArtifactProductionVersionInput;
}
