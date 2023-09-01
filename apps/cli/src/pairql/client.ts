// auto-generated, do not edit
import type { Result } from '@friends-library/pairql';
import type * as P from './pairs';
import { query } from '../query';

export function latestArtifactProductionVersion(
  input: P.LatestArtifactProductionVersion.Input,
): Promise<Result<P.LatestArtifactProductionVersion.Output>> {
  return query<
    P.LatestArtifactProductionVersion.Input,
    P.LatestArtifactProductionVersion.Output
  >(input, `LatestArtifactProductionVersion`);
}

export function createArtifactProductionVersion(
  input: P.CreateArtifactProductionVersion.Input,
): Promise<Result<P.CreateArtifactProductionVersion.Output>> {
  return query<
    P.CreateArtifactProductionVersion.Input,
    P.CreateArtifactProductionVersion.Output
  >(input, `CreateArtifactProductionVersion`);
}
