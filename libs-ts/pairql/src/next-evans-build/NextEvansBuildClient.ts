// auto-generated, do not edit
import type { Env } from '../types';
import type Result from '../Result';
import type * as P from './pairs';
import Client from '../Client';

export default class NextEvansBuildClient extends Client {
  public constructor(env: Env, getToken: () => string | undefined) {
    super(env, `next-evans-build`, getToken);
  }

  public static node(
    process: { argv: string[]; env: Record<string, string | undefined> },
    pattern?: string | undefined,
  ): NextEvansBuildClient {
    return Client.inferNode(NextEvansBuildClient, process, pattern);
  }

  public static web(
    href: string,
    getToken: () => string | undefined,
  ): NextEvansBuildClient {
    return Client.inferWeb(NextEvansBuildClient, href, getToken);
  }

  public async documentPage(input: P.DocumentPage.Input): Promise<P.DocumentPage.Output> {
    const result = await this.query<P.DocumentPage.Output>(input, `DocumentPage`);
    return result.unwrap();
  }

  public async explorePage(input: P.ExplorePage.Input): Promise<P.ExplorePage.Output> {
    const result = await this.query<P.ExplorePage.Output>(input, `ExplorePage`);
    return result.unwrap();
  }

  public async friendPage(input: P.FriendPage.Input): Promise<P.FriendPage.Output> {
    const result = await this.query<P.FriendPage.Output>(input, `FriendPage`);
    return result.unwrap();
  }

  public async friendsPage(input: P.FriendsPage.Input): Promise<P.FriendsPage.Output> {
    const result = await this.query<P.FriendsPage.Output>(input, `FriendsPage`);
    return result.unwrap();
  }

  public async publishedDocumentSlugs(
    input: P.PublishedDocumentSlugs.Input,
  ): Promise<P.PublishedDocumentSlugs.Output> {
    const result = await this.query<P.PublishedDocumentSlugs.Output>(
      input,
      `PublishedDocumentSlugs`,
    );
    return result.unwrap();
  }

  public async publishedFriendSlugs(
    input: P.PublishedFriendSlugs.Input,
  ): Promise<P.PublishedFriendSlugs.Output> {
    const result = await this.query<P.PublishedFriendSlugs.Output>(
      input,
      `PublishedFriendSlugs`,
    );
    return result.unwrap();
  }

  public documentPageResult(
    input: P.DocumentPage.Input,
  ): Promise<Result<P.DocumentPage.Output>> {
    return this.query<P.DocumentPage.Output>(input, `DocumentPage`);
  }

  public explorePageResult(
    input: P.ExplorePage.Input,
  ): Promise<Result<P.ExplorePage.Output>> {
    return this.query<P.ExplorePage.Output>(input, `ExplorePage`);
  }

  public friendPageResult(
    input: P.FriendPage.Input,
  ): Promise<Result<P.FriendPage.Output>> {
    return this.query<P.FriendPage.Output>(input, `FriendPage`);
  }

  public friendsPageResult(
    input: P.FriendsPage.Input,
  ): Promise<Result<P.FriendsPage.Output>> {
    return this.query<P.FriendsPage.Output>(input, `FriendsPage`);
  }

  public publishedDocumentSlugsResult(
    input: P.PublishedDocumentSlugs.Input,
  ): Promise<Result<P.PublishedDocumentSlugs.Output>> {
    return this.query<P.PublishedDocumentSlugs.Output>(input, `PublishedDocumentSlugs`);
  }

  public publishedFriendSlugsResult(
    input: P.PublishedFriendSlugs.Input,
  ): Promise<Result<P.PublishedFriendSlugs.Output>> {
    return this.query<P.PublishedFriendSlugs.Output>(input, `PublishedFriendSlugs`);
  }
}
