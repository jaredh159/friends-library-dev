import { query as pqlQuery, inferEnvNode } from '@friends-library/pairql';
import type { Result } from '@friends-library/pairql';

export function query<Input, Output>(
  input: Input,
  operation: string,
): Promise<Result<Output>> {
  const [env, token] = inferEnvNode(process);
  return pqlQuery<Output>(env, `Dev`, operation, input, token);
}
