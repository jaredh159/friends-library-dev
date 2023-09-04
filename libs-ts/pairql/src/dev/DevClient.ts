// auto-generated, do not edit
import type { Env } from '../types';
import type Result from '../Result';
import type * as P from './pairs';
import Client from '../Client';

export default class DevClient extends Client {
  public constructor(env: Env, getToken: () => string | undefined) {
    super(env, `dev`, getToken);
  }

  public static node(
    process: { argv: string[]; env: Record<string, string | undefined> },
    pattern?: string | undefined,
  ): DevClient {
    return Client.inferNode(DevClient, process, pattern);
  }

  public static web(href: string, getToken: () => string | undefined): DevClient {
    return Client.inferWeb(DevClient, href, getToken);
  }

  public latestArtifactProductionVersion(
    input: P.LatestArtifactProductionVersion.Input,
  ): Promise<Result<P.LatestArtifactProductionVersion.Output>> {
    return this.query<P.LatestArtifactProductionVersion.Output>(
      input,
      `LatestArtifactProductionVersion`,
    );
  }

  public createArtifactProductionVersion(
    input: P.CreateArtifactProductionVersion.Input,
  ): Promise<Result<P.CreateArtifactProductionVersion.Output>> {
    return this.query<P.CreateArtifactProductionVersion.Output>(
      input,
      `CreateArtifactProductionVersion`,
    );
  }

  public editorDocumentMap(
    input: P.EditorDocumentMap.Input,
  ): Promise<Result<P.EditorDocumentMap.Output>> {
    return this.query<P.EditorDocumentMap.Output>(input, `EditorDocumentMap`);
  }
}
