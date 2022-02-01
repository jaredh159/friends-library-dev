import { ApolloError } from '@apollo/client';

class ResultHelpers {
  apolloError(apolloError: ApolloError | undefined): Result<never, string> {
    return this.error(`${apolloError ?? `missing data`}`);
  }

  error<T>(error: T): Result<never, T> {
    return { success: false, error: error };
  }

  success<T>(value: T): Result<T, never> {
    return { success: true, value: value };
  }
}

export default new ResultHelpers();
