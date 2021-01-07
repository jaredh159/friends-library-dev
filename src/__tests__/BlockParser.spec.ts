import { NODE as n } from '../types';
import BlockParser from '../parsers/BlockParser';
import { getChapter, getParser } from './helpers';
import BlockNode from '../nodes/BlockNode';
import stripIndent from 'strip-indent';

describe(`BlockParser.parse()`, () => {
  it(`can parse a simple paragraph`, () => {
    const block = getParsedBlock(`
      Hello world
    `);
    expect(block.toJSON()).toMatchObject({
      type: n.BLOCK,
      children: [
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: 'Hello world' }],
        },
      ],
    });
  });

  it(`can parse a paragraph with context`, () => {
    const block = getParsedBlock(`
      [quote, ,]
      ____
      First para

      [.offset]
      With context

      Last para
      ____
    `);
    expect(block.toJSON()).toMatchObject({
      type: n.BLOCK,
      children: [
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: 'First para' }],
        },
        {
          type: n.PARAGRAPH,
          context: { classList: [`offset`] },
          children: [{ type: n.TEXT, value: 'With context' }],
        },
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: 'Last para' }],
        },
      ],
    });
  });

  it(`can parse a blockquote`, () => {
    const block = getParsedBlock(`
      [quote, ,]
      ____
      Hello world
      ____
    `);

    expect(block.toJSON()).toMatchObject({
      type: n.BLOCK,
      context: { type: `quote` },
      children: [
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: 'Hello world' }],
        },
      ],
    });
  });

  it(`can parse a blockquote with multiple paragraphs`, () => {
    const block = getParsedBlock(`
      [quote, ,]
      ____
      Hello world

      Goodbye world

      Hello
      Papa
      ____
    `);

    expect(block.toJSON()).toMatchObject({
      type: n.BLOCK,
      context: { type: `quote` },
      children: [
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: 'Hello world' }],
        },
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: 'Goodbye world' }],
        },
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: 'Hello Papa' }],
        },
      ],
    });
  });

  it(`can parse an open-block`, () => {
    const block = getParsedBlock(`
      [.embedded-content-document.letter]
      --

      [.salutation]
      Dear friend

      Hello friend

      [.signed-section-signature]
      George

      --
    `);

    expect(block.toJSON()).toMatchObject({
      type: n.BLOCK,
      blockType: `open`,
      context: { classList: [`embedded-content-document`, `letter`] },
      children: [
        {
          type: n.PARAGRAPH,
          context: { classList: [`salutation`] },
          children: [{ type: n.TEXT, value: `Dear friend` }],
        },
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: `Hello friend` }],
        },
        {
          type: n.PARAGRAPH,
          context: { classList: [`signed-section-signature`] },
          children: [{ type: n.TEXT, value: `George` }],
        },
      ],
    });
  });

  it(`can parse an example-block`, () => {
    const block = getParsedBlock(`
      [.postscript]
      ====

      Hello world

      ====
    `);

    expect(block.toJSON()).toMatchObject({
      type: n.BLOCK,
      blockType: `example`,
      context: { classList: [`postscript`] },
      children: [
        {
          type: n.PARAGRAPH,
          children: [{ type: n.TEXT, value: `Hello world` }],
        },
      ],
    });
  });
});

function getParsedBlock(adoc: string): BlockNode {
  const parser = getParser(stripIndent(adoc).trim() + `\n`);
  const blockParser = new BlockParser(parser);
  return blockParser.parse(getChapter());
}
