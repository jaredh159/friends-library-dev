export default class ChapterResult {
  public constructor(
    protected index: number,
    public content: string,
    public shortHeading: string,
    public isIntermediateTitle: boolean,
    public sequenceNumber?: number,
    public nonSequenceTitle?: string,
    protected customId?: string,
  ) {}

  public get id(): string {
    return this.customId ?? this.slug;
  }

  public get slug(): string {
    return `chapter-${this.index + 1}`;
  }

  public get isSequenced(): boolean {
    return typeof this.sequenceNumber === `number`;
  }

  public get hasNonSequenceTitle(): boolean {
    return typeof this.nonSequenceTitle === `string`;
  }
}
