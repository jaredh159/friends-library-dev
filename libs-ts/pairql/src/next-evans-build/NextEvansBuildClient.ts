// auto-generated, do not edit
import type { Env } from '../types';
import type Result from '../Result';
import type * as P from './pairs';
import Client from '../Client';

export default class NextEvansBuileClient extends Client {
  public constructor(env: Env, getToken: () => string | undefined) {
    super(env, `next-evans-build`, getToken);
  }

  public static node(
    process: { argv: string[]; env: Record<string, string | undefined> },
    pattern?: string | undefined,
  ): NextEvansBuileClient {
    return Client.inferNode(NextEvansBuileClient, process, pattern);
  }

  public static web(
    href: string,
    getToken: () => string | undefined,
  ): NextEvansBuileClient {
    return Client.inferWeb(NextEvansBuileClient, href, getToken);
  }

  public async friendsPage(input: P.FriendsPage.Input): Promise<P.FriendsPage.Output> {
    const result = await this.query<P.FriendsPage.Output>(input, `FriendsPage`);
    return result.unwrap();
  }

  public friendsPageResult(
    input: P.FriendsPage.Input,
  ): Promise<Result<P.FriendsPage.Output>> {
    return this.query<P.FriendsPage.Output>(input, `FriendsPage`);
  }
}
