import React from 'react';
import { gql } from '@apollo/client';
import type { SelectableDocuments } from '../../graphql/SelectableDocuments';
import { SELECTABLE_DOCUMENTS_FIELDS } from '../../client';
import { useQueryResult } from '../../lib/query';
import * as empty from '../../lib/empty';
import { EditFriend } from './EditFriend';

const CreateFriend: React.FC = () => {
  const query = useQueryResult<SelectableDocuments>(QUERY_SELECTABLE_DOCUMENTS);
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  return (
    <EditFriend
      friend={empty.friend()}
      selectableDocuments={query.data.selectableDocuments}
    />
  );
};

export default CreateFriend;

const QUERY_SELECTABLE_DOCUMENTS = gql`
  ${SELECTABLE_DOCUMENTS_FIELDS}
  query SelectableDocuments {
    selectableDocuments: getDocuments {
      ...SelectableDocumentsFields
    }
  }
`;
