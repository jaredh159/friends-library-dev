import { TOKEN as t, NODE as n } from '../types';
import { getPara, getParser, assertAllNodesHaveTokens } from './helpers';

describe(`Parser.parseUntil() using parselets`, () => {
  it(`can handle text nodes`, () => {
    const parser = getParser(`Hello world\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    expect(nodes).toHaveLength(1);
    expect(nodes[0]).toMatchObject({
      type: n.TEXT,
      value: `Hello world`,
    });
  });

  it(`can handle right single curlies`, () => {
    const parser = getParser(`priest\`'s\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    expect(nodes).toHaveLength(3);
    expect(nodes).toMatchObject([
      { type: n.TEXT, value: `priest` },
      { type: n.SYMBOL, value: `\`'`, meta: { subType: t.RIGHT_SINGLE_CURLY } },
      { type: n.TEXT, value: `s` },
    ]);
  });

  test(`RIGHT_BRACKET in standard context consumed as text`, () => {
    const parser = getParser(`Hello world]\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(1);
    expect(nodes[0]).toMatchObject({
      type: n.TEXT,
      value: `Hello world]`,
    });
  });

  test(`unambiguous content brackets consumed as text`, () => {
    const parser = getParser(`[Hello] world\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(1);
    expect(nodes[0]).toMatchObject({
      type: n.TEXT,
      value: `[Hello] world`,
    });
  });

  it(`can handle triple-plus passthrough`, () => {
    const parser = getParser(`+++[+++mark\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(2);
    expect(nodes).toMatchObject([
      { type: n.INLINE_PASSTHROUGH, value: `[` },
      { type: n.TEXT, value: `mark` },
    ]);
  });

  it(`can handle symbols at end of line`, () => {
    const parser = getParser(`world.\`"\nHello\n\n`);
    const nodes = parser.parseUntil(getPara(), t.DOUBLE_EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(3);
    expect(nodes).toMatchObject([
      { type: n.TEXT, value: `world.` },
      { type: n.SYMBOL, value: `\`"`, meta: { subType: t.RIGHT_DOUBLE_CURLY } },
      { type: n.TEXT, value: ` Hello` },
    ]);
  });

  it(`can handle emphasis child nodes`, () => {
    const parser = getParser(`Hello _world_ foo\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(3);
    expect(nodes).toMatchObject([
      { type: n.TEXT, value: `Hello ` },
      { type: n.EMPHASIS, children: [{ type: n.TEXT, value: `world` }] },
      { type: n.TEXT, value: ` foo` },
    ]);
    expect(nodes[1]!.endToken).toMatchObject({
      type: t.UNDERSCORE,
      literal: `_`,
    });
  });

  it(`can handle STRONG child nodes`, () => {
    const parser = getParser(`Hello **world** foo\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(3);
    expect(nodes).toMatchObject([
      { type: n.TEXT, value: `Hello ` },
      { type: n.STRONG, children: [{ type: n.TEXT, value: `world` }] },
      { type: n.TEXT, value: ` foo` },
    ]);
  });

  test(`nested nodes`, () => {
    const parser = getParser(`Hello **_world_** foo\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(3);
    expect(nodes).toMatchObject([
      { type: n.TEXT, value: `Hello ` },
      {
        type: n.STRONG,
        children: [
          {
            type: n.EMPHASIS,
            children: [
              {
                type: n.TEXT,
                value: `world`,
              },
            ],
          },
        ],
      },
      { type: n.TEXT, value: ` foo` },
    ]);
  });

  it(`throws if node doesn't close properly`, () => {
    const parser = getParser(`_Hello\n`);
    expect(() => parser.parseUntil(getPara(), t.EOL)).toThrow(/unclosed/i);
  });

  it(`throws if nodes close out of order`, () => {
    const parser = getParser(`_Hello **world_ foo**\n`);
    expect(() => parser.parseUntil(getPara(), t.EOL)).toThrow(/unclosed STRONG/i);
  });

  it(`can move through newlines`, () => {
    const parser = getParser(`Hello\nworld\n\n`);
    const nodes = parser.parseUntil(getPara(), t.DOUBLE_EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(1);
    expect(nodes[0]).toMatchObject({ type: n.TEXT, value: `Hello world` });
  });

  it(`doesn't move through newlines, if should stop`, () => {
    const parser = getParser(`Hello\nworld\n\n`);
    const nodes = parser.parseUntil(getPara(), t.EOL);
    nodes.forEach(assertAllNodesHaveTokens);
    expect(nodes).toHaveLength(1);
    expect(nodes[0]).toMatchObject({ type: n.TEXT, value: `Hello` });
  });
});
