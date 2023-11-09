// auto-generated, do not edit
import type { Env } from '../types';
import type Result from '../Result';
import type * as P from './pairs';
import Client from '../Client';

export default class OrderClient extends Client {
  public constructor(env: Env, getToken: () => string | undefined) {
    super(env, `order`, getToken);
  }

  public static node(
    process: { argv: string[]; env: Record<string, string | undefined> },
    pattern?: string | undefined,
  ): OrderClient {
    return Client.inferNode(OrderClient, process, pattern);
  }

  public static web(href: string, getToken: () => string | undefined): OrderClient {
    return Client.inferWeb(OrderClient, href, getToken);
  }

  public createOrder(input: P.CreateOrder.Input): Promise<Result<P.CreateOrder.Output>> {
    return this.query<P.CreateOrder.Output>(input, `CreateOrder`);
  }

  public getPrintJobExploratoryMetadata(
    input: P.GetPrintJobExploratoryMetadata.Input,
  ): Promise<Result<P.GetPrintJobExploratoryMetadata.Output>> {
    return this.query<P.GetPrintJobExploratoryMetadata.Output>(
      input,
      `GetPrintJobExploratoryMetadata`,
    );
  }
}
