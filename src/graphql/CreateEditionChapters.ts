/* tslint:disable */
/* eslint-disable */
// @generated
// This file was automatically generated and should not be edited.

import { CreateEditionChapterInput } from './globalTypes';

// ====================================================
// GraphQL mutation operation: CreateEditionChapters
// ====================================================

export interface CreateEditionChapters_chapters {
  __typename: 'EditionChapter';
  id: string;
}

export interface CreateEditionChapters {
  chapters: CreateEditionChapters_chapters[];
}

export interface CreateEditionChaptersVariables {
  input: CreateEditionChapterInput[];
}
