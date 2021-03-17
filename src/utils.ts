import { AstNode, TOKEN as t, Token, Visitable } from '@friends-library/parser';

let _chapterLines: string[] = [];

/**
 * Convenience singleton for better ergonomics
 * when building up chapter markup across multiple
 * files and functions
 */
class ChapterMarkup {
  private paused = false;

  public pause() {
    this.paused = true;
  }

  public unpause() {
    this.paused = false;
  }

  public push(str: string): void {
    !this.paused && _chapterLines.push(str);
  }

  public append(str: string): void {
    if (this.paused) {
      return;
    }
    _chapterLines[_chapterLines.length - 1] = `${
      _chapterLines[_chapterLines.length - 1]
    }${str}`;
  }

  public reset(): void {
    _chapterLines = [];
  }

  public get(): string[] {
    return _chapterLines;
  }
}

export const chapterMarkup = new ChapterMarkup();
const c = chapterMarkup;

export function symbolOutput(node: AstNode): string {
  switch (node.meta.subType) {
    case t.LEFT_DOUBLE_CURLY:
      return `“`;
    case t.RIGHT_DOUBLE_CURLY:
      return `”`;
    case t.LEFT_SINGLE_CURLY:
      return `‘`;
    case t.RIGHT_SINGLE_CURLY:
      return `’`;
    case t.DOUBLE_DASH:
      return `—`;
    case t.POUND_SYMBOL:
    case t.DOLLAR_SYMBOL:
    case t.DEGREE_SYMBOL:
      return node.value;
    default:
      node.print(true);
      throw new Error(`unhandled symbol: ${node.value}`);
  }
}

export function joinTokens(tokens: Token[]): string {
  return tokens
    .map((token) => {
      switch (token.type) {
        case t.LEFT_DOUBLE_CURLY:
          return `“`;
        case t.RIGHT_DOUBLE_CURLY:
          return `”`;
        case t.LEFT_SINGLE_CURLY:
          return `‘`;
        case t.RIGHT_SINGLE_CURLY:
          return `’`;
        case t.DOUBLE_DASH:
          return `—`;
        default:
          return token.literal;
      }
    })
    .join(``);
}

export function wrap(
  tag: string | ((node: AstNode) => string | null),
  classList?: string[],
): Visitable<unknown> {
  return {
    enter({ node }) {
      const el = typeof tag === `function` ? tag(node) : tag;
      el && c.push(`<${el}${classAttr(node, classList) || classAttr(node.parent)}>`);
    },
    exit({ node }) {
      const el = typeof tag === `function` ? tag(node) : tag;
      el && c.push(`</${el}>`);
    },
  };
}

export function classAttr(node: AstNode, classes?: string[]): string {
  classes = [...(classes ?? []), ...consumeClasses(node)];
  return classes.length ? ` class="${classes.join(` `)}"` : ``;
}

export function consumeClasses(node: AstNode): string[] {
  if (node.getMetaData(CONSUMED_CLASSES) !== true) {
    node.setMetaData(CONSUMED_CLASSES, true);
    return [...(node.context?.classList ?? [])];
  }
  return [];
}

export function trimTrailingPunctuation(str: string): string {
  if (str.endsWith(`etc.`)) {
    return str;
  }
  return str.replace(/[.,;:]$/, ``);
}

export const utils = {
  consumeClasses,
  classAttr,
  wrap,
  joinTokens,
  symbolOutput,
  trimTrailingPunctuation,
};

const CONSUMED_CLASSES = `__CONSUMED_CLASSES`;
