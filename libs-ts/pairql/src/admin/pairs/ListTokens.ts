// auto-generated, do not edit

export namespace ListTokens {
  export type Input = void;

  export type Output = Array<{
    id: UUID;
    description: string;
    uses?: number;
    scopes: Array<{
      id: UUID;
      type:
        | 'all'
        | 'queryDownloads'
        | 'mutateDownloads'
        | 'queryOrders'
        | 'mutateOrders'
        | 'queryArtifactProductionVersions'
        | 'mutateArtifactProductionVersions'
        | 'queryEntities'
        | 'mutateEntities'
        | 'queryTokens'
        | 'mutateTokens';
    }>;
    createdAt: ISODateString;
  }>;
}
