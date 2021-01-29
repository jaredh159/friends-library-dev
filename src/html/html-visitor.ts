import { Visitor } from '@friends-library/parser';
import { utils as u, chapterMarkup as c, wrap } from '../utils';
import AttributedQuoteBlockVisitor from './AttributedQuoteBlockVisitor';
import HeadingVisitor from './HeadingVisitor';
import ParagraphVisitor from './ParagraphVisitor';

type Output = Array<string[]>;

const visitor: Visitor<Output> = {
  chapter: {
    enter({ node, output, index }) {
      c.reset();
      output.push(c.get());
      const { context } = node;
      const classes = [`chapter`, `chapter-${index + 1}`, ...u.consumeClasses(node)];
      const attrs = context?.shortTitle
        ? ` data-short-title="${u.joinTokens(context.shortTitle)}"`
        : ``;
      const id = context?.id ? ` id="${context.id}"` : ` `;
      c.push(`<div${id}class="${classes.join(` `)}"${attrs}>`);
    },
    exit() {
      c.push(`</div>`);
    },
  },

  block: {
    dispatch(node) {
      if (node.isAttributedQuoteBlock()) {
        return new AttributedQuoteBlockVisitor();
      } else if (node.isPoetryBlock()) {
        return wrap((node) => (node.isInFootnote() ? `span` : `section`), ['poetry']);
      } else if (node.isQuoteBlock()) {
        return wrap(`blockquote`);
      } else if (node.isExampleBlock() || node.isOpenBlock()) {
        return wrap(`div`);
      } else {
        return {};
      }
    },
  },

  symbol: {
    enter({ node }) {
      c.append(u.symbolOutput(node));
    },
  },

  paragraphInFootnote: wrap((n) => (n.hasSiblings() ? `span` : null), [
    `footnote-paragraph`,
  ]),

  thematicBreak: {
    enter({ node }) {
      if (node.hasClass(`asterism`)) {
        c.push(`<div class="asterism">*&#160;&#160;*&#160;&#160;*</div>`);
      } else if (node.hasClass(`small-break`)) {
        c.push(`<div class="small-break"></div>`);
      }
    },
  },

  text: {
    enter({ node }) {
      c.append(node.value);
    },
  },

  discoursePartIdentifier: {
    enter({ node }) {
      c.append(`<em>${node.value}</em>`);
    },
  },

  paragraph: new ParagraphVisitor(),
  footnote: wrap(`span`, [`footnote`]),
  unorderedList: wrap(`ul`),
  listItem: wrap(`li`),
  emphasis: wrap(`em`),
  headingSegment: wrap(`span`),
  descriptionList: wrap(`dl`),
  descriptionListItemTerm: wrap(`dt`),
  descriptionListItemContent: wrap(`dd`),
  verseLine: wrap(`span`, [`verse-line`]),
  verseStanza: wrap((n) => (n.isInFootnote() ? `span` : `div`), [`verse-stanza`]),

  ...HeadingVisitor,
};
export default visitor;
