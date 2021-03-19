import { Visitor } from '@friends-library/parser';
import { utils as u, wrap, chapterMarkup as c } from '../utils';

const PrimitivesVisitor: Visitor<Array<string[]>> = {
  entity: {
    enter({ node }) {
      // always use decimal versions, works for BOTH ebook and browsers
      c.append(node.expectStringMetaData(`decimalEntity`));
    },
  },

  text: {
    enter({ node }) {
      c.append(node.value);
    },
  },

  redacted: {
    enter({ node }) {
      c.append(node.value);
    },
  },

  blockPassthrough: {
    enter({ node }) {
      c.append(node.value);
    },
  },

  inlinePassthrough: {
    enter({ node }) {
      c.append(node.value);
    },
  },

  symbol: {
    enter({ node }) {
      c.append(u.symbolOutput(node));
    },
  },

  inline: wrap(`span`),
  unorderedList: wrap(`ul`),
  listItem: wrap(`li`),
  strong: wrap(`b`),
  emphasis: wrap(`em`),
  descriptionList: wrap(`dl`),
  descriptionListItemTerm: wrap(`dt`),
  descriptionListItemContent: wrap(`dd`),
  verseLine: wrap(`span`, [`verse-line`]),
  verseStanza: wrap((n) => (n.isInFootnote() ? `span` : `div`), [`verse-stanza`]),
};

export default PrimitivesVisitor;
