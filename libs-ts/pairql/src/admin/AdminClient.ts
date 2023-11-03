// auto-generated, do not edit
import type { Env } from '../types';
import type Result from '../Result';
import type * as P from './pairs';
import Client from '../Client';

export default class AdminClient extends Client {
  public constructor(env: Env, getToken: () => string | undefined) {
    super(env, `admin`, getToken);
  }

  public static node(
    process: { argv: string[]; env: Record<string, string | undefined> },
    pattern?: string | undefined,
  ): AdminClient {
    return Client.inferNode(AdminClient, process, pattern);
  }

  public static web(href: string, getToken: () => string | undefined): AdminClient {
    return Client.inferWeb(AdminClient, href, getToken);
  }

  public async listFriends(input: P.ListFriends.Input): Promise<P.ListFriends.Output> {
    const result = await this.query<P.ListFriends.Output>(input, `ListFriends`);
    return result.unwrap();
  }

  public listFriendsResult(
    input: P.ListFriends.Input,
  ): Promise<Result<P.ListFriends.Output>> {
    return this.query<P.ListFriends.Output>(input, `ListFriends`);
  }
}
