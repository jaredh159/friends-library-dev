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

  public async editDocument(input: P.EditDocument.Input): Promise<P.EditDocument.Output> {
    const result = await this.query<P.EditDocument.Output>(input, `EditDocument`);
    return result.unwrap();
  }

  public async editFriend(input: P.EditFriend.Input): Promise<P.EditFriend.Output> {
    const result = await this.query<P.EditFriend.Output>(input, `EditFriend`);
    return result.unwrap();
  }

  public async getOrder(input: P.GetOrder.Input): Promise<P.GetOrder.Output> {
    const result = await this.query<P.GetOrder.Output>(input, `GetOrder`);
    return result.unwrap();
  }

  public async listDocuments(
    input: P.ListDocuments.Input,
  ): Promise<P.ListDocuments.Output> {
    const result = await this.query<P.ListDocuments.Output>(input, `ListDocuments`);
    return result.unwrap();
  }

  public async listFriends(input: P.ListFriends.Input): Promise<P.ListFriends.Output> {
    const result = await this.query<P.ListFriends.Output>(input, `ListFriends`);
    return result.unwrap();
  }

  public async listOrders(input: P.ListOrders.Input): Promise<P.ListOrders.Output> {
    const result = await this.query<P.ListOrders.Output>(input, `ListOrders`);
    return result.unwrap();
  }

  public async listTokens(input: P.ListTokens.Input): Promise<P.ListTokens.Output> {
    const result = await this.query<P.ListTokens.Output>(input, `ListTokens`);
    return result.unwrap();
  }

  public async selectableDocuments(
    input: P.SelectableDocuments.Input,
  ): Promise<P.SelectableDocuments.Output> {
    const result = await this.query<P.SelectableDocuments.Output>(
      input,
      `SelectableDocuments`,
    );
    return result.unwrap();
  }

  public editDocumentResult(
    input: P.EditDocument.Input,
  ): Promise<Result<P.EditDocument.Output>> {
    return this.query<P.EditDocument.Output>(input, `EditDocument`);
  }

  public editFriendResult(
    input: P.EditFriend.Input,
  ): Promise<Result<P.EditFriend.Output>> {
    return this.query<P.EditFriend.Output>(input, `EditFriend`);
  }

  public getOrderResult(input: P.GetOrder.Input): Promise<Result<P.GetOrder.Output>> {
    return this.query<P.GetOrder.Output>(input, `GetOrder`);
  }

  public listDocumentsResult(
    input: P.ListDocuments.Input,
  ): Promise<Result<P.ListDocuments.Output>> {
    return this.query<P.ListDocuments.Output>(input, `ListDocuments`);
  }

  public listFriendsResult(
    input: P.ListFriends.Input,
  ): Promise<Result<P.ListFriends.Output>> {
    return this.query<P.ListFriends.Output>(input, `ListFriends`);
  }

  public listOrdersResult(
    input: P.ListOrders.Input,
  ): Promise<Result<P.ListOrders.Output>> {
    return this.query<P.ListOrders.Output>(input, `ListOrders`);
  }

  public listTokensResult(
    input: P.ListTokens.Input,
  ): Promise<Result<P.ListTokens.Output>> {
    return this.query<P.ListTokens.Output>(input, `ListTokens`);
  }

  public selectableDocumentsResult(
    input: P.SelectableDocuments.Input,
  ): Promise<Result<P.SelectableDocuments.Output>> {
    return this.query<P.SelectableDocuments.Output>(input, `SelectableDocuments`);
  }
}
