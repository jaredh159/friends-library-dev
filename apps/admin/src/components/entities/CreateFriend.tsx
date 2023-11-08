import React from 'react';
import { useQuery } from '../../lib/query';
import * as empty from '../../lib/empty';
import api from '../../api-client';
import { EditFriend } from './EditFriend';

const CreateFriend: React.FC = () => {
  const query = useQuery(() => api.selectableDocuments());
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  return <EditFriend friend={empty.friend()} selectableDocuments={query.data} />;
};

export default CreateFriend;
