import type Parser from '../Parser';
import type { Parselet, AstNode, Token } from '../types';
import Node from '../nodes/AstNode';
import { NODE as n, TOKEN as t } from '../types';

const symbol: Parselet = (parser, parent) => {
  const current = parser.current;

  if (isMoney(parser)) {
    return parseMoney(parser, parent);
  }

  const node = new Node(n.SYMBOL, parent, {
    subType: current.type,
    value: current.literal,
    startToken: current,
    endToken: current,
  });

  const symbolType = current.type;
  parser.consume();

  // lines ending with `--` should join directly to next line
  if (
    symbolType === t.DOUBLE_DASH &&
    parser.currentIs(t.EOL) &&
    parent.type !== n.VERSE_LINE // except for verses ending in `--`
  ) {
    parser.consume();
  }

  return node;
};

export default symbol;

function parseMoney(parser: Parser, parent: AstNode): AstNode {
  const money = new Node(n.MONEY, parent, {
    value: parser.current.literal + parser.peek.literal,
    startToken: parser.current,
    endToken: parser.peek,
  });

  let numberStr = parser.peek.literal;
  parser.consume(); // currency symbol
  parser.consume(); // start of amount

  if (parser.currentOneOf(t.COMMA, t.DOT) && isNumber(parser.peek)) {
    money.value += parser.consume().literal;
    const moreDigits = parser.consume();
    money.endToken = moreDigits;
    numberStr += moreDigits.literal;
    money.value += moreDigits.literal;
  }

  money.meta.data = {
    currencyType: money.startToken.type,
    amount: Number(numberStr),
  };
  return money;
}

function isMoney(parser: Parser): boolean {
  if (!parser.currentOneOf(t.POUND_SYMBOL, t.DOLLAR_SYMBOL)) {
    return false;
  }
  return isNumber(parser.peek);
}

function isNumber(token: Token): boolean {
  return token.type === t.TEXT && !!token.literal.match(/^\d+/);
}
