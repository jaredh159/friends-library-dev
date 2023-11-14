import React, { useState, useEffect } from 'react';
import type { Result, PqlError } from '@friends-library/pairql';
import FullscreenLoading from '../components/FullscreenLoading';
import InfoMessage from '../components/InfoMessage';

type QueryResult<T> =
  | { isResolved: false; unresolvedElement: React.ReactElement }
  | { isResolved: true; data: T };

export function useQuery<T>(fn: () => Promise<Result<T>>): QueryResult<T> {
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
            unresolvedElement: <QueryError error={error} />,
          }),
        }),
      );
    });
  }, [fn.toString()]); // eslint-disable-line react-hooks/exhaustive-deps
  return result;
}

const QueryError: React.FC<{ error: PqlError }> = ({ error }) => (
  <InfoMessage type="error">
    {`Error: ${error.detail ?? `${error.type}: ${error.id}`}`}
  </InfoMessage>
);
