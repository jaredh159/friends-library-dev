import { useQuery } from '@apollo/client';
import React from 'react';
import type {
  ApolloError,
  DocumentNode,
  OperationVariables,
  QueryHookOptions,
  TypedDocumentNode,
} from '@apollo/client';
import FullscreenLoading from '../components/FullscreenLoading';
import InfoMessage from '../components/InfoMessage';

type QueryResult<T> =
  | { isResolved: false; unresolvedElement: React.ReactElement }
  | { isResolved: true; data: T };

export function useQueryResult<
  Data,
  Vars extends OperationVariables = OperationVariables,
>(
  query: DocumentNode | TypedDocumentNode<Data, Vars>,
  options?: QueryHookOptions<Data, Vars>,
): QueryResult<Data> {
  const { loading, data, error } = useQuery<Data, Vars>(query, {
    ...options,
    errorPolicy: `all`,
  });
  if (loading) {
    return { isResolved: false, unresolvedElement: <FullscreenLoading /> };
  }
  if (!data) {
    return { isResolved: false, unresolvedElement: <QueryError error={error} /> };
  }

  return { isResolved: true, data };
}

const QueryError: React.FC<{ error: ApolloError | undefined }> = ({ error }) => (
  <InfoMessage type="error">
    {!error ? `Missing data` : `Error: ${error.message.replace(/^error\.?/, ``)}`}
  </InfoMessage>
);
