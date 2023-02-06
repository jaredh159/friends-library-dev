import { AstNode, NODE as n, traverse, Visitor } from '@friends-library/parser';
import { HTML_DEC_ENTITIES as e } from '@friends-library/types';
import { joinTokens, symbolOutput, trimTrailingPunctuation } from './utils';

export default function evalShortChapterHeading(chapter: AstNode): string {
  if (chapter.type !== n.CHAPTER) {
    throw new Error(`Unexpected non-chapter arg passed to evalShortChapterHeading()`);
  }

  // always evaluate to set up the rich metadata on the chapter...
  const heading = chapter.expectFirstChild(n.HEADING);
  const output = { string: ``, buffer: `` };
  traverse(heading, visitor, output, {});
  const shortHeading = trimTrailingPunctuation(output.string);

  // ...but prefer an explicitly set short title
  if (chapter.context?.shortTitle) {
    return joinTokens(chapter.context.shortTitle);
  }

  return shortHeading;
}

const visitor: Visitor<{ string: string; buffer: string }> = {
  headingSequenceIdentifier: {
    enter({ node, output }) {
      output.string = `${node.getMetaData(`kind`)} ${node.getMetaData(`roman`)}`;
      if (node.nextSibling()) {
        output.string += ` ${e.MDASH} `;
      }
    },
  },

  headingTitle: {
    enter({ output }) {
      // buffer up everything evaluated inside `HEADING_TITLE` node
      // so we can set the metaData
      output.buffer = output.string;
      output.string = ``;
    },
    exit({ node, output }) {
      node.chapter.setMetaData(`nonSequenceTitle`, output.string);
      // restore output from buffer
      output.string = output.buffer + output.string;
    },
  },

  symbolInHeadingSegment: {
    enter({ node, output }) {
      if (node.parent.meta.level === 1) {
        output.string += symbolOutput(node);
      }
    },
  },

  textInHeadingSegment: {
    enter({ node, output }) {
      if (node.parent.meta.level === 1) {
        output.string += node.value;
      }
    },
  },

  entityInHeadingSegment: {
    enter({ node, output }) {
      if (node.parent.meta.level === 1) {
        output.string += node.value;
      }
    },
  },

  entityInHeading: {
    enter({ node, output }) {
      output.string += node.value;
    },
  },

  text: {
    enter({ node, output }) {
      if (!node.isInFootnote()) {
        output.string += node.value;
      }
    },
  },

  symbol: {
    enter({ node, output }) {
      output.string += symbolOutput(node);
    },
  },

  inlinePassthrough: {
    enter({ node, output }) {
      if (node.value.match(/^<br ?\/?>$/)) {
        output.string += ` `;
      }
    },
  },
};
