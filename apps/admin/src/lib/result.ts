import type { ApolloError } from '@apollo/client';

function apolloError(apolloError: ApolloError | undefined): Result<never, string> {
  return error(`${apolloError ?? `missing data`}`);
}

function error<T>(error: T): Result<never, T> {
  return { success: false, error: error };
}

function success<T>(value: T): Result<T, never> {
  return { success: true, value: value };
}

export default {
  error,
  apolloError,
  success,
};
