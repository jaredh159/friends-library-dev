// auto-generated, do not edit
import type { Env } from '../types';
import type Result from '../Result';
import type * as P from './pairs';
import Client from '../Client';

export default class EvansBuildClient extends Client {
  public constructor(env: Env, getToken: () => string | undefined) {
    super(env, `evans-build`, getToken);
  }

  public static node(
    process: { argv: string[]; env: Record<string, string | undefined> },
    pattern?: string | undefined,
  ): EvansBuildClient {
    return Client.inferNode(EvansBuildClient, process, pattern);
  }

  public static web(href: string, getToken: () => string | undefined): EvansBuildClient {
    return Client.inferWeb(EvansBuildClient, href, getToken);
  }

  public async getDocumentDownloadCounts(
    input: P.GetDocumentDownloadCounts.Input,
  ): Promise<P.GetDocumentDownloadCounts.Output> {
    const result = await this.query<P.GetDocumentDownloadCounts.Output>(
      input,
      `GetDocumentDownloadCounts`,
    );
    return result.unwrap();
  }

  public async getFriends(input: P.GetFriends.Input): Promise<P.GetFriends.Output> {
    const result = await this.query<P.GetFriends.Output>(input, `GetFriends`);
    return result.unwrap();
  }

  public getDocumentDownloadCountsResult(
    input: P.GetDocumentDownloadCounts.Input,
  ): Promise<Result<P.GetDocumentDownloadCounts.Output>> {
    return this.query<P.GetDocumentDownloadCounts.Output>(
      input,
      `GetDocumentDownloadCounts`,
    );
  }

  public getFriendsResult(
    input: P.GetFriends.Input,
  ): Promise<Result<P.GetFriends.Output>> {
    return this.query<P.GetFriends.Output>(input, `GetFriends`);
  }
}
