import { Visitor } from '@friends-library/parser';
import { utils as u, chapterMarkup as c } from '../utils';
import PrimitivesVisitor from './PrimitivesVisitor';
import { ebookFootnoteData } from './FootnoteVisitor';
import { Lang } from '@friends-library/types';

const EbookFootnoteContentVisitor: Visitor<
  Array<string[]>,
  { target: `ebook`; lang: Lang }
> = {
  collection: {
    enter({ output }) {
      c.reset();
      output.push(c.get());
      c.push(`<div id="footnotes">`);
    },
    exit() {
      c.push(`</div>`);
    },
  },

  footnote: {
    enter({ node }) {
      const [num, marker, file] = ebookFootnoteData(node, true);
      c.push(`<div class="footnote" id="fn__${num}">`);
      c.push(`<a href="${file}.xhtml#fn-call__${num}">${marker}</a>`);
    },
    exit({ node }) {
      const [num, , file] = ebookFootnoteData(node, true);
      c.push(`<a href="${file}.xhtml#fn-call__${num}">\u23CE</a>`);
      c.push(`</div>`);
    },
  },

  blockInFootnote: u.wrap(`span`, [`poetry`]),

  paragraphInFootnote: u.wrap((n) => (n.hasSiblings() ? `span` : null), [
    `footnote-paragraph`,
  ]),

  textInFootnote: {
    enter({ node }) {
      c.append(node.value);
    },
  },

  ...PrimitivesVisitor,
};

export default EbookFootnoteContentVisitor;
