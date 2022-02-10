import { gql } from '@apollo/client';
import { getClient } from '@friends-library/db';

export default getClient({
  env: `dev`,
  token: localStorage.getItem(`token`),
});

export const SELECTABLE_DOCUMENTS_FIELDS = gql`
  fragment SelectableDocumentsFields on Document {
    id
    title
    friend {
      lang
      alphabeticalName
    }
  }
`;

export const EDIT_EDITION_FIELDS = gql`
  fragment EditEditionFields on Edition {
    id
    type
    paperbackSplits
    paperbackOverrideSize
    editor
    isbn {
      code
    }
    isDraft
    document {
      id
    }
  }
`;

export const EDIT_DOCUMENT_FIELDS = gql`
  ${EDIT_EDITION_FIELDS}
  fragment EditDocumentFields on Document {
    id
    altLanguageId
    title
    slug
    filename
    published
    originalTitle
    incomplete
    description
    partialDescription
    featuredDescription
    friend {
      id
      name
      lang
    }
    editions {
      ...EditEditionFields
    }
    tags {
      id
      type
      document {
        id
      }
    }
    relatedDocuments {
      id
      description
      document {
        id
      }
      parentDocument {
        id
      }
    }
  }
`;
