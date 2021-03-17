import { Visitor } from '@friends-library/parser';
import evalShortChapterHeading from '../short-chapter-heading';
import { utils as u, chapterMarkup as c, wrap } from '../utils';
import AttributedQuoteBlockVisitor from './AttributedQuoteBlockVisitor';
import HeadingVisitor from './HeadingVisitor';
import ParagraphVisitor from './ParagraphVisitor';
import FootnoteVisitor from './FootnoteVisitor';
import PrimitivesVisitor from './PrimitivesVisitor';

type Output = Array<string[]>;
type Context = { target: 'pdf' | 'ebook' };

const documentVisitor: Visitor<Output, Context> = {
  chapter: {
    enter({ node, output, index, context: { target } }) {
      c.reset();
      output.push(c.get());
      const { context } = node;
      const classes = [`chapter`, `chapter-${index + 1}`, ...u.consumeClasses(node)];
      const attrs =
        context?.shortTitle && target == `pdf`
          ? ` data-short-title="${u.joinTokens(context.shortTitle)}" `
          : ``;
      const id = context?.id ? context.id : `chapter-${index + 1}`;
      node.setMetaData(`id`, id);
      c.push(`<div id="${id}" class="${classes.join(` `)}"${attrs}>`);
    },
    exit({ node }) {
      node.setMetaData(`shortChapterHeading`, evalShortChapterHeading(node));
      c.push(`</div>`);
    },
  },

  block: {
    dispatch({ node }) {
      if (node.isAttributedQuoteBlock()) {
        return new AttributedQuoteBlockVisitor();
      } else if (node.isPoetryBlock()) {
        return wrap(`section`, ['poetry']);
      } else if (node.isQuoteBlock()) {
        return wrap(`blockquote`);
      } else if (node.isExampleBlock() || node.isOpenBlock()) {
        return wrap(`div`);
      } else {
        return {};
      }
    },
  },

  thematicBreak: {
    enter({ node }) {
      if (node.hasClass(`asterism`)) {
        c.push(`<div class="asterism">*&#160;&#160;*&#160;&#160;*</div>`);
      } else if (node.hasClass(`small-break`)) {
        c.push(`<div class="small-break"></div>`);
      }
    },
  },

  postscriptIdentifier: {
    enter({ node }) {
      c.append(`<em>${node.value}</em>`);
    },
  },

  discoursePartIdentifier: {
    enter({ node }) {
      c.append(`<em>${node.value}</em>`);
    },
  },

  headingSegment: {
    enter({ node }) {
      c.append(`<span class="heading-segment heading-segment--${node.meta.level}">`);
    },
    exit() {
      c.append(`</span>`);
    },
  },

  paragraph: new ParagraphVisitor(),
  // headingSegment: wrap(`span`),

  ...PrimitivesVisitor,
  ...HeadingVisitor,
  ...FootnoteVisitor,
};

export default documentVisitor;
