import {
  ApolloError,
  DocumentNode,
  OperationVariables,
  QueryHookOptions,
  TypedDocumentNode,
  useQuery,
} from '@apollo/client';
import React from 'react';
import FullscreenLoading from '../components/FullscreenLoading';
import InfoMessage from '../components/InfoMessage';

type QueryResult<T> =
  | { isResolved: false; unresolvedElement: React.ReactElement }
  | { isResolved: true; data: T };

export function useQueryResult<Data, Vars = OperationVariables>(
  query: DocumentNode | TypedDocumentNode<Data, Vars>,
  options?: QueryHookOptions<Data, Vars>,
): QueryResult<Data> {
  const { loading, data, error } = useQuery<Data, Vars>(query, options);
  if (loading) {
    return { isResolved: false, unresolvedElement: <FullscreenLoading /> };
  }
  if (!data || error) {
    return { isResolved: false, unresolvedElement: <QueryError error={error} /> };
  }

  return { isResolved: true, data };
}

const QueryError: React.FC<{ error: ApolloError | undefined }> = ({ error }) => {
  return (
    <InfoMessage type="error">
      {!error ? `Missing data` : `Error: ${error.message.replace(/^error\.?/, ``)}`}
    </InfoMessage>
  );
};
