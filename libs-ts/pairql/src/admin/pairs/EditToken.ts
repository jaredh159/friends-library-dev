// auto-generated, do not edit

export namespace EditToken {
  export type Input = UUID;

  export interface Output {
    id: UUID;
    value: UUID;
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
  }
}
