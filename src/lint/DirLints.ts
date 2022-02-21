import { LintResult } from '@friends-library/adoc-lint';

interface FileLintData {
  lints: LintResult[];
  path: string;
  adoc: string;
}

export default class DirLints {
  protected map: Map<string, FileLintData>;

  public constructor() {
    this.map = new Map();
  }

  public set(path: string, data: { adoc: string; lints: LintResult[] }): void {
    this.map.set(path, { ...data, path });
  }

  public get(path: string): FileLintData | undefined {
    return this.map.get(path);
  }

  public fixable(): LintResult[] {
    return this.all().filter((lint) => lint.fixable === true);
  }

  public unfixable(): LintResult[] {
    return this.all().filter((lint) => lint.fixable !== true);
  }

  public all(): LintResult[] {
    return [...this.map].reduce((acc, [, { lints }]) => {
      return [...acc, ...lints];
    }, [] as LintResult[]);
  }

  public count(): number {
    return this.all().length;
  }

  public numFixable(): number {
    return this.fixable().length;
  }

  public numUnfixable(): number {
    return this.unfixable().length;
  }

  public toArray(): [string, FileLintData][] {
    return [...this.map];
  }

  public [Symbol.iterator](): [string, FileLintData][] {
    // @ts-ignore
    return this.map[Symbol.iterator]();
  }
}
