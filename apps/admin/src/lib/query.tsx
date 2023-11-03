import { useQuery } from '@apollo/client';
import React, { useState, useEffect } from 'react';
import type { Result, PqlError } from '@friends-library/pairql';
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

export function useFetchResult<T>(fn: () => Promise<Result<T>>): QueryResult<T> {
  const [result, setResult] = useState<QueryResult<T>>({
    isResolved: false,
    unresolvedElement: <FullscreenLoading />,
  });
  useEffect(() => {
    fn().then((result) => {
      setResult(
        result.reduce<QueryResult<T>>({
          success: (data) => ({ isResolved: true, data }),
          error: (error) => ({
            isResolved: false,
            unresolvedElement: <FetchError error={error} />,
          }),
        }),
      );
    });
  }, []); // eslint-disable-line react-hooks/exhaustive-deps
  return result;
}

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

const FetchError: React.FC<{ error: PqlError }> = ({ error }) => (
  <InfoMessage type="error">
    {`Error: ${error.detail ?? `${error.type}: ${error.id}`}`}
  </InfoMessage>
);

const QueryError: React.FC<{ error: ApolloError | undefined }> = ({ error }) => (
  <InfoMessage type="error">
    {!error ? `Missing data` : `Error: ${error.message.replace(/^error\.?/, ``)}`}
  </InfoMessage>
);
