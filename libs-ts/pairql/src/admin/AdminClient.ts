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

  public createEntity(
    input: P.CreateEntity.Input,
  ): Promise<Result<P.CreateEntity.Output>> {
    return this.query<P.CreateEntity.Output>(input, `CreateEntity`);
  }

  public deleteEntity(
    input: P.DeleteEntity.Input,
  ): Promise<Result<P.DeleteEntity.Output>> {
    return this.query<P.DeleteEntity.Output>(input, `DeleteEntity`);
  }

  public editDocument(
    input: P.EditDocument.Input,
  ): Promise<Result<P.EditDocument.Output>> {
    return this.query<P.EditDocument.Output>(input, `EditDocument`);
  }

  public editFriend(input: P.EditFriend.Input): Promise<Result<P.EditFriend.Output>> {
    return this.query<P.EditFriend.Output>(input, `EditFriend`);
  }

  public editToken(input: P.EditToken.Input): Promise<Result<P.EditToken.Output>> {
    return this.query<P.EditToken.Output>(input, `EditToken`);
  }

  public getOrder(input: P.GetOrder.Input): Promise<Result<P.GetOrder.Output>> {
    return this.query<P.GetOrder.Output>(input, `GetOrder`);
  }

  public listDocuments(
    input: P.ListDocuments.Input,
  ): Promise<Result<P.ListDocuments.Output>> {
    return this.query<P.ListDocuments.Output>(input, `ListDocuments`);
  }

  public listFriends(input: P.ListFriends.Input): Promise<Result<P.ListFriends.Output>> {
    return this.query<P.ListFriends.Output>(input, `ListFriends`);
  }

  public listOrders(input: P.ListOrders.Input): Promise<Result<P.ListOrders.Output>> {
    return this.query<P.ListOrders.Output>(input, `ListOrders`);
  }

  public listTokens(input: P.ListTokens.Input): Promise<Result<P.ListTokens.Output>> {
    return this.query<P.ListTokens.Output>(input, `ListTokens`);
  }

  public orderEditions(
    input: P.OrderEditions.Input,
  ): Promise<Result<P.OrderEditions.Output>> {
    return this.query<P.OrderEditions.Output>(input, `OrderEditions`);
  }

  public selectableDocuments(
    input: P.SelectableDocuments.Input,
  ): Promise<Result<P.SelectableDocuments.Output>> {
    return this.query<P.SelectableDocuments.Output>(input, `SelectableDocuments`);
  }

  public updateEntity(
    input: P.UpdateEntity.Input,
  ): Promise<Result<P.UpdateEntity.Output>> {
    return this.query<P.UpdateEntity.Output>(input, `UpdateEntity`);
  }
}
