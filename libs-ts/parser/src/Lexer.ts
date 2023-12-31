import type { AsciidocFile, Lexer as LexerInterface, Token, TokenType } from './types';
import { TOKEN as t } from './types';

interface Line {
  content: string;
  number: number;
  charIdx: number;
  filename?: string;
}

export default class Lexer implements LexerInterface {
  public inputs: AsciidocFile[] = [];
  public inputIdx = -1;
  public line: null | Line = null;
  public lines: Line[] = [];
  public lastToken?: Token;
  public bufferedToken?: Token;
  private passThruState?: 'block' | 'inline';

  public constructor(...inputs: AsciidocFile[]) {
    this.inputs = inputs;
  }

  public tokens(): Token[] {
    let current = this.nextToken();
    const tokens: Token[] = [current];
    while (current.type !== t.EOD) {
      current = this.nextToken();
      tokens.push(current);
    }
    return tokens;
  }

  public nextToken(): Token {
    if (this.lastToken?.type === t.EOD) {
      return this.lastToken;
    }

    let tok: Token;
    if (this.bufferedToken) {
      tok = this.bufferedToken;
      this.bufferedToken = undefined;
      return tok;
    }

    const line = this.currentLine();
    if (!line) {
      return this.makeToken(t.EOD, null);
    }

    if (this.passThruState === `inline`) {
      return this.getInlinePassThru(line);
    } else if (this.passThruState === `block`) {
      return this.getBlockPassThru(line);
    }

    const char = line.content[line.charIdx];
    if (char === undefined) {
      this.line = null;
      return this.nextToken();
    }

    switch (char) {
      case `,`:
        return this.makeToken(t.COMMA, line);
      case `?`:
        return this.makeToken(t.QUESTION_MARK, line);
      case `;`:
        return this.makeToken(t.SEMICOLON, line);
      case `!`:
        return this.makeToken(t.EXCLAMATION_MARK, line);
      case `.`:
        return this.makeToken(t.DOT, line);
      case `[`:
        return this.makeToken(t.LEFT_BRACKET, line);
      case `]`:
        return this.makeToken(t.RIGHT_BRACKET, line);
      case `(`:
        return this.makeToken(t.LEFT_PARENS, line);
      case `)`:
        return this.makeToken(t.RIGHT_PARENS, line);
      case `^`:
        return this.makeToken(t.CARET, line);
      case `_`:
        return this.makeGreedyToken(t.UNDERSCORE, line);
      case `|`:
        return this.makeToken(t.PIPE, line);
      case ` `:
        return this.makeGreedyToken(t.WHITESPACE, line);
      case `=`:
        return this.makeGreedyToken(t.EQUALS, line);
      case `$`:
        return this.makeToken(t.DOLLAR_SYMBOL, line);
      case `£`:
        return this.makeToken(t.POUND_SYMBOL, line);
      case `#`:
        return this.makeToken(t.HASH, line);
      case `°`:
        return this.makeToken(t.DEGREE_SYMBOL, line);
      case `\n`: {
        tok = this.makeToken(t.EOL, line);
        const nextLine = this.nextLine();
        if (nextLine && nextLine.content === `\n`) {
          tok.type = t.DOUBLE_EOL;
          this.setLiteral(tok, `\n\n`, line);
          this.nextLine();
        }
        return tok;
      }
      case `&`: {
        const entityMatch = line.content.substring(line.charIdx).match(/^&#?[a-z0-9]+;/);
        if (entityMatch !== null) {
          tok = this.makeToken(t.ENTITY, line);
          this.setLiteral(tok, entityMatch[0] || ``, line);
          return tok;
        } else {
          return this.makeToken(t.ENTITY, line);
        }
      }
      case `/`:
        if (line.charIdx === 0 && this.peekChar() === `/`) {
          line.charIdx += line.content.length;
          return this.nextToken();
        }
        return this.makeToken(t.FORWARD_SLASH, line);
      case `>`:
        if (this.peekChar() === `>`) {
          tok = this.makeGreedyToken(t.XREF_CLOSE, line);
          if (tok.literal.length !== 2) {
            tok.type = t.ILLEGAL;
          }
          return tok;
        } else {
          return this.makeToken(t.ILLEGAL, line);
        }
      case `<`:
        if (this.peekChar() === `<`) {
          tok = this.makeGreedyToken(t.XREF_OPEN, line);
          if (tok.literal.length !== 2) {
            tok.type = t.ILLEGAL;
          }
          return tok;
        } else {
          return this.makeToken(t.ILLEGAL, line);
        }
      case `+`:
        if (this.peekChar() === `+`) {
          tok = this.makeGreedyToken(t.TRIPLE_PLUS, line);
          if (tok.literal.length === 3) {
            this.passThruState = `inline`;
            return tok;
          } else if (tok.literal.length === 4) {
            tok.type = t.QUADRUPLE_PLUS;
            this.passThruState = `block`;
            return tok;
          } else {
            tok.type = t.ILLEGAL;
          }
          return tok;
        } else {
          return this.makeToken(t.PLUS, line);
        }
      case `:`:
        tok = this.makeGreedyToken(t.DOUBLE_COLON, line);
        if (tok.literal.length === 1) {
          tok.type = t.COLON;
        } else if (tok.literal.length !== 2) {
          tok.type = t.ILLEGAL;
        }
        return tok;
      case `{`:
        if (line.charIdx === 0 && line.content === `${FOOTNOTE_PARA_SPLIT}\n`) {
          tok = this.makeToken(t.FOOTNOTE_PARAGRAPH_SPLIT, line);
          return this.setLiteral(tok, FOOTNOTE_PARA_SPLIT, line);
        }
        return this.makeToken(t.ILLEGAL, line);
      case `*`:
        tok = this.makeGreedyToken(t.ASTERISK, line);
        if (tok.literal.length === 3) {
          tok.type = t.TRIPLE_ASTERISK;
        } else if (tok.literal.length === 2) {
          tok.type = t.DOUBLE_ASTERISK;
        } else if (tok.literal.length !== 1) {
          tok.type = t.ILLEGAL;
        }
        return tok;
      case `-`:
        if (line.content.substring(line.charIdx) === `${FOOTNOTE_STANZA}\n`) {
          tok = this.makeToken(t.FOOTNOTE_STANZA, line);
          return this.setLiteral(tok, FOOTNOTE_STANZA, line);
        }
        return this.makeGreedyToken(t.DOUBLE_DASH, line, 2);
      case `\``:
        if (this.peekChar() === `"`) {
          tok = this.makeToken(t.RIGHT_DOUBLE_CURLY, line, false);
          return this.requireAppendChar(tok, line);
        } else if (this.peekChar() === `'`) {
          tok = this.makeToken(t.RIGHT_SINGLE_CURLY, line, false);
          return this.requireAppendChar(tok, line);
        } else {
          return this.makeToken(t.BACKTICK, line);
        }
      case `'`:
        if (this.peekChar() === `\``) {
          tok = this.makeToken(t.LEFT_SINGLE_CURLY, line, false);
          return this.requireAppendChar(tok, line);
        } else if (this.peekChar() === `'`) {
          return this.makeGreedyToken(t.THEMATIC_BREAK, line, 3);
        } else {
          return this.makeToken(t.STRAIGHT_SINGLE_QUOTE, line);
        }
      case `"`:
        if (this.peekChar() === `\``) {
          tok = this.makeToken(t.LEFT_DOUBLE_CURLY, line, false);
          return this.requireAppendChar(tok, line);
        } else {
          return this.makeToken(t.STRAIGHT_DOUBLE_QUOTE, line);
        }
      default: {
        tok = this.makeToken(t.TEXT, line, false);
        while (!isTextBoundaryChar(this.peekChar())) {
          const nextChar = this.requireNextChar();
          tok.literal += nextChar;
          tok.column.end += 1;
        }
        line.charIdx++;
        const embedMatch = tok.literal.match(/(--|::)/);
        if (embedMatch) {
          const reverseChars = tok.literal.length - (embedMatch.index ?? 0);
          tok.column.end -= reverseChars;
          line.charIdx -= reverseChars;
          tok.literal = tok.literal.substring(0, tok.literal.length - reverseChars);
        }
        if (tok.literal === `footnote` && this.currentChar() === `:`) {
          tok.type = t.FOOTNOTE_PREFIX;
          tok.literal += `:`;
          line.charIdx++;
        } else if (
          // first test just for perf
          tok.literal[tok.literal.length - 1] === `e` &&
          this.currentChar() === `:` &&
          tok.literal.match(/footnote$/)
        ) {
          tok.literal = tok.literal.replace(/footnote$/, ``);
          tok.column.end -= `footnote`.length;
          line.charIdx -= `footnote`.length;
        }
        return tok;
      }
    }
  }

  private requireAppendChar(tok: Token, line: Line): Token {
    tok.literal += this.requireNextChar();
    tok.column.end++;
    line.charIdx++;
    return tok;
  }

  private requireNextChar(): string {
    const line = this.line;
    if (line === null) {
      throw new Error(`Expected a next char`);
    }
    line.charIdx += 1;
    const nextChar = line.content[line.charIdx];
    if (nextChar === undefined) {
      throw new Error(`Expected a next char`);
    }

    return nextChar;
  }

  private makeToken(type: TokenType, line: Line | null, advanceChar = true): Token {
    let column = { start: 1, end: 1 };
    if (line) {
      column = { start: line.charIdx + 1, end: line.charIdx + 1 };
    } else if (this.lastToken) {
      column = { start: this.lastToken.column.end, end: this.lastToken.column.end };
    }

    const token: Token = {
      type,
      literal: line?.content[line.charIdx] ?? ``,
      filename: line?.filename ?? this.lastToken?.filename,
      line: line?.number ?? this.lastToken?.line ?? 1,
      column,
    };
    this.lastToken = token;
    if (advanceChar && line) {
      line.charIdx++;
    }
    return token;
  }

  private makeGreedyToken(type: TokenType, line: Line, requiredLength?: number): Token {
    const tok = this.makeToken(type, line, false);
    while (tok.literal[0] && this.peekChar() === tok.literal[0]) {
      tok.literal += this.requireNextChar();
      tok.column.end++;
    }
    line.charIdx++;
    if (typeof requiredLength === `number` && tok.literal.length !== requiredLength) {
      tok.type = t.ILLEGAL;
    }
    return tok;
  }

  private setLiteral(token: Token, literal: string, line: Line): Token {
    token.literal = literal;
    token.column.end += literal.length - 1;
    line.charIdx += literal.length - 1;
    return token;
  }

  private currentChar(): string | null {
    const line = this.line;
    if (line === null) {
      return null;
    }
    return line.content[line.charIdx] ?? null;
  }

  private peekChar(): string | null {
    const line = this.line;
    if (line === null) {
      return null;
    }
    return line.content[line.charIdx + 1] ?? null;
  }

  private currentLine(): Line | null {
    if (this.line === null) {
      return this.nextLine();
    }

    return this.line;
  }

  private nextLine(): Line | null {
    if (this.lines.length) {
      const line = this.lines.shift() as Line;
      this.line = line;
      return line;
    }

    // we reached the end of a file
    if (this.inputIdx > -1) {
      this.bufferedToken = this.makeToken(t.EOF, null);
    }

    this.inputIdx++;
    const nextInput = this.inputs[this.inputIdx];
    if (this.inputIdx >= this.inputs.length || !nextInput) {
      return null;
    }

    this.lines = nextInput.adoc.split(/\n/g).map((line, lineIdx) => ({
      charIdx: 0,
      content: `${line}\n`,
      number: lineIdx + 1,
      filename: nextInput.filename,
    }));

    if (nextInput.adoc.endsWith(`\n`)) {
      // throw away false empty line created by splitting on `\n`
      this.lines.pop();
    }

    return this.nextLine();
  }

  private getBlockPassThru(line: Line): Token {
    // first EOL after `++++`
    if (line.charIdx === 4 && line.content[line.charIdx] === `\n`) {
      const tk = this.makeToken(t.EOL, line);
      this.nextLine();
      return tk;
    }

    if (line.content === `++++\n`) {
      this.passThruState = undefined;
      return this.makeGreedyToken(t.QUADRUPLE_PLUS, line);
    }

    // make a raw passthrough line, keep returning lines until we exit passthrough
    const token = this.makeToken(t.RAW_PASSTHROUGH, line);
    this.setLiteral(token, line.content, line);
    this.nextLine();
    return token;
  }

  private getInlinePassThru(line: Line): Token {
    const restOfLine = line.content.substring(line.charIdx);
    const token = this.makeToken(t.RAW_PASSTHROUGH, line);
    this.setLiteral(token, restOfLine.replace(/\+\+\+.*\n/, ``), line);
    this.passThruState = undefined;
    this.bufferedToken = this.makeGreedyToken(t.TRIPLE_PLUS, line);
    return token;
  }
}

function isTextBoundaryChar(char: string | null): boolean {
  if (char === null) {
    return true;
  }
  return BOUNDARY_MAP[char] ?? false;
}

const FOOTNOTE_PARA_SPLIT = `{footnote-paragraph-split}`;
const FOOTNOTE_STANZA = `- - - - - -`;

const BOUNDARY_MAP: { [k: string]: true } = {
  ' ': true,
  '\n': true,
  '.': true,
  ',': true,
  ']': true,
  '[': true,
  '^': true,
  '`': true,
  "'": true,
  _: true,
  '"': true,
  '+': true,
  $: true,
  '°': true,
  '&': true,
  '#': true,
  '(': true,
  ')': true,
  '*': true,
  '=': true,
  '!': true,
  '?': true,
  ':': true,
  ';': true,
  '>': true,
  '<': true,
};
