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

  public createArtifactProductionVersion(
    input: P.CreateArtifactProductionVersion.Input,
  ): Promise<Result<P.CreateArtifactProductionVersion.Output>> {
    return this.query<P.CreateArtifactProductionVersion.Output>(
      input,
      `CreateArtifactProductionVersion`,
    );
  }

  public createEditionChapters(
    input: P.CreateEditionChapters.Input,
  ): Promise<Result<P.CreateEditionChapters.Output>> {
    return this.query<P.CreateEditionChapters.Output>(input, `CreateEditionChapters`);
  }

  public deleteEntities(
    input: P.DeleteEntities.Input,
  ): Promise<Result<P.DeleteEntities.Output>> {
    return this.query<P.DeleteEntities.Output>(input, `DeleteEntities`);
  }

  public editorDocumentMap(
    input: P.EditorDocumentMap.Input,
  ): Promise<Result<P.EditorDocumentMap.Output>> {
    return this.query<P.EditorDocumentMap.Output>(input, `EditorDocumentMap`);
  }

  public getAudios(input: P.GetAudios.Input): Promise<Result<P.GetAudios.Output>> {
    return this.query<P.GetAudios.Output>(input, `GetAudios`);
  }

  public getEdition(input: P.GetEdition.Input): Promise<Result<P.GetEdition.Output>> {
    return this.query<P.GetEdition.Output>(input, `GetEdition`);
  }

  public getEditionImpression(
    input: P.GetEditionImpression.Input,
  ): Promise<Result<P.GetEditionImpression.Output>> {
    return this.query<P.GetEditionImpression.Output>(input, `GetEditionImpression`);
  }

  public latestArtifactProductionVersion(
    input: P.LatestArtifactProductionVersion.Input,
  ): Promise<Result<P.LatestArtifactProductionVersion.Output>> {
    return this.query<P.LatestArtifactProductionVersion.Output>(
      input,
      `LatestArtifactProductionVersion`,
    );
  }

  public updateAudio(input: P.UpdateAudio.Input): Promise<Result<P.UpdateAudio.Output>> {
    return this.query<P.UpdateAudio.Output>(input, `UpdateAudio`);
  }

  public updateAudioPart(
    input: P.UpdateAudioPart.Input,
  ): Promise<Result<P.UpdateAudioPart.Output>> {
    return this.query<P.UpdateAudioPart.Output>(input, `UpdateAudioPart`);
  }

  public upsertEditionImpression(
    input: P.UpsertEditionImpression.Input,
  ): Promise<Result<P.UpsertEditionImpression.Output>> {
    return this.query<P.UpsertEditionImpression.Output>(input, `UpsertEditionImpression`);
  }
}
