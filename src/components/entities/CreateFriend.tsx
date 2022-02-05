import React from 'react';
import { gql } from '@apollo/client';
import { SELECTABLE_DOCUMENTS_FIELDS } from '../../client';
import { SelectableDocuments } from '../../graphql/SelectableDocuments';
import { EditFriend } from './EditFriend';
import { useQueryResult } from '../../lib/query';
import * as emptyEntities from '../../lib/empty-entities';

const CreateFriend: React.FC = () => {
  const query = useQueryResult<SelectableDocuments>(QUERY_SELECTABLE_DOCUMENTS);
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  return (
    <EditFriend
      friend={emptyEntities.friend()}
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
