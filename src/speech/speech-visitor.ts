/* eslint @typescript-eslint/explicit-module-boundary-types: "off" */
import { DocPrecursor } from '@friends-library/types';
import { Visitor, AstNode, NodeType, traverse } from '@friends-library/parser';
import { symbolOutput } from '../utils';

type Output = string[];
type Context = { dpc: DocPrecursor; inlineFootnote?: boolean; quotifyEpigraph?: boolean };
type Data = { node: AstNode; output: Output; context: Context };

const visitor: Visitor<Output, Context> = {
  document: {
    enter({ output, context, node }) {
      output.push(context.dpc.meta.title.toUpperCase());
      output.push(``);
      output.push(`by ${context.dpc.meta.author.name.toUpperCase()}\n`);
      output.push(``);
      node.document().epigraphs.children.forEach((epigraph) => {
        const epigraphLines: string[] = [];
        traverse(epigraph, visitor, epigraphLines, context);
        output.push(epigraphLines.join(``));
      });
    },

    exit({ output, context: { dpc } }) {
      output.push(``);
      output.push(`THE END.\n\n`);
      output.push(`Published by FRIENDS LIBRARY PUBLISHING.\n`);
      output.push(
        `Download free books from early members of the Religious Society of Friends (Quakers) in a variety of formats at www.friendslibrary.com.\n`,
      );
      output.push(`Public domain in the USA.\n`);
      output.push(`Contact the publishers at info@friendslibrary.com.\n`);
      output.push(`ISBN: ${dpc.meta.isbn}\n`);
      output.push(`Text revision: ${dpc.revision.sha} - `);
      append(output, new Date(dpc.revision.timestamp * 1000).toLocaleDateString());
    },
  },

  footnote: {
    enter({ node, output, context }) {
      if (node.children.length === 1) {
        context.inlineFootnote = true;
        append(output, ` [footnote: `);
        const paragraph = node.children.shift();
        node.children = (paragraph ?? { children: [] }).children;
      } else {
        output.push(``);
        output.push(`[footnote:]`);
        output.push(``);
      }
    },
    exit({ context, output }) {
      if (context.inlineFootnote) {
        context.inlineFootnote = false;
        append(output, ` --returning to text.]`);
      } else {
        output.push(``);
        output.push(`[--returning to text.]`);
        output.push(``);
        output.push(``);
      }
    },
  },

  listItem: {
    enter({ output }) {
      append(output, `- `);
    },
    exit: pushLine,
  },

  money: {
    enter({ node, output }) {
      let moneyStr = node.value.replace(/^./, ``);
      const currencyType = node.meta?.data?.currencyType;
      moneyStr += ` ${currencyType === `POUND_SYMBOL` ? `pound` : `dollar`}`;
      const amount = Number(node.meta?.data?.amount);
      if (amount > 1) {
        moneyStr += `s`;
      }
      append(output, moneyStr);
    },
  },

  verseStanza: {
    enter: pushLine,
  },

  verseLine: {
    exit: pushLine,
  },

  symbol: {
    enter({ node, output }) {
      append(output, symbolOutput(node));
    },
  },

  entity: {
    enter({ node, output }) {
      switch (node.meta.subType) {
        case `ELLIPSES`:
          return append(output, `...`);
        case `EMDASH`:
          return append(output, `—`);
        case `AMPERSAND`:
          return append(output, `&`);
        default:
          node.print(true);
          throw new Error(`unhandled entity: ${node.value}`);
      }
    },
  },

  paragraph: {
    enter({ output, node, context }) {
      const parent = node.parent;
      output.push(``);
      const SIGNATURE = `signed-section-signature`;
      if (hasClass(parent, SIGNATURE) || hasClass(node, SIGNATURE)) {
        append(output, `Signed, `);
      }

      // wrap quotes around epigraphs
      if (parent.meta.subType === `quote` && parent.context?.type === `epigraph`) {
        const first = node.children[0];
        if (first?.type === `SYMBOL` && first.meta.subType === `LEFT_DOUBLE_CURLY`) {
          return;
        }
        append(output, `“`);
        context.quotifyEpigraph = true;
      }
    },
    exit({ output, context }) {
      if (context.quotifyEpigraph) {
        append(output, `”`);
        context.quotifyEpigraph = false;
      }
      output.push(``);
    },
  },

  heading: {
    enter: pushLine,
    exit: pushLine,
  },

  headingSequenceIdentifier: {
    enter({ node, output }) {
      append(output, node.value.toUpperCase());
    },
  },

  redacted: {
    enter({ output }) {
      append(output, `[name removed]`);
    },
  },

  text: {
    enter(data) {
      const { node, output } = data;

      if ((getParentOfType(node, `HEADING`)?.meta.level ?? 5) < 4) {
        return append(output, node.value.toUpperCase());
      }

      if (isChildOfType(node, `DESCRIPTION_LIST_ITEM_TERM`)) {
        return append(output, node.value.toUpperCase());
      }

      appendNodeValue(data);
    },
  },

  descriptionListItemTerm: {
    exit({ output }) {
      append(output, `: `);
    },
  },

  descriptionList: {
    enter: pushLine,
  },

  descriptionListItem: {
    exit({ output }) {
      output.push(``);
      output.push(``);
    },
  },

  unorderedList: {
    enter({ node, output }) {
      if (hasClass(node, `chapter-synopsis`)) {
        node.children = [];
      } else {
        output.push(``);
      }
    },
  },

  block: {
    exit({ node, output }) {
      const { meta, context } = node;
      if (
        meta?.subType === `quote` &&
        (context?.quoteSource || context?.quoteAttribution)
      ) {
        append(output, ` —`);
        if (context.quoteAttribution) {
          append(output, context.quoteAttribution.map((t) => t.literal).join(``));
          if (context.quoteSource) {
            append(output, `, `);
          }
        }
        if (context.quoteSource) {
          append(output, context.quoteSource.map((t) => t.literal).join(``));
        }
        output.push(`\n`);
      }
    },
  },

  node: {
    enter: appendNodeValue,
  },
};

export default visitor;

function pushLine({ output }: Data): void {
  output.push(``);
}

function appendNodeValue({ node, output }: Data): void {
  append(output, node.value);
}

function append(output: Output, str: string): void {
  let line = output.pop() ?? ``;
  line += str;
  output.push(line);
}

function getParentOfType(node: AstNode, nodeType: NodeType): AstNode | null {
  let current = node.parent;
  while (current.type !== `DOCUMENT`) {
    if (current.type === nodeType) {
      return current;
    }
    current = current.parent;
  }
  return null;
}

export function parentHasClass(node: AstNode, className: string): boolean {
  let current = node.parent;
  while (current.type !== `DOCUMENT`) {
    if (hasClass(current, className)) {
      return true;
    }
    current = current.parent;
  }
  return false;
}

function isChildOfType(node: AstNode, nodeType: NodeType): boolean {
  return getParentOfType(node, nodeType) !== null;
}

function hasClass(node: AstNode, className: string): boolean {
  return node.context?.classList.includes(className) ?? false;
}
