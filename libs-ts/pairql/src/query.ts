import type { Domain, Env } from './types';
import { isPqlError } from './PqlError';
import Result from './Result';

export async function query<T>(
  env: Env,
  domain: Domain,
  operation: string,
  input: unknown,
  token?: string,
): Promise<Result<T>> {
  const headers: Record<string, string> = { 'Content-Type': `application/json` };

  if (token) {
    headers[`Authorization`] = `Bearer ${token}`;
  }

  const init: RequestInit = {
    method: `POST`,
    headers,
    body: input === undefined ? undefined : JSON.stringify(input),
  };

  try {
    const res = await fetch(endpoint(env, domain, operation), init);
    const json = await res.json();
    if (res.status >= 300) {
      return errorResult(json, res.status, env);
    } else {
      return Result.success(json);
    }
  } catch (error) {
    return errorResult(error, 500, env);
  }
}

function endpoint(env: Env, domain: Domain, operation: string): string {
  const path = `pairql/${domain.toLowerCase()}/${operation}`;
  switch (env) {
    case `dev`:
      return `http://127.0.0.1:8080/${path}`;
    case `staging`:
      return `https://api--staging.friendslibrary.com/${path}`;
    case `prod`:
      return `https://api.friendslibrary.com/${path}`;
  }
}

function errorResult(error: unknown, statusCode: number, env: Env): Result<never> {
  if (env !== `prod`) {
    console.error(`PqlError`, error); // eslint-disable-line no-console
  }
  return Result.error(
    isPqlError(error)
      ? error
      : {
          id: `95375ae5`,
          requestId: `unknown`,
          type: `other`,
          detail: `Unexpected error: ${JSON.stringify(error)}`,
          statusCode,
        },
  );
}
