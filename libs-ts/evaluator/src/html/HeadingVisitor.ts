import { Visitable, AstNode, Visitor } from '@friends-library/parser';
import evalShortChapterHeading from '../short-chapter-heading';
import { utils as u, chapterMarkup as c } from '../utils';

const HeadingVisitor: Visitor<Array<string[]>> = {
  heading: {
    dispatch({ node }): Visitable<Array<string[]>> {
      if (!isChapter(node)) {
        return {
          enter({ node }) {
            const el = `h${level(node)}`;
            const id = node.parent.context?.id ? ` id="${node.parent.context.id}" ` : ``;
            c.append(`<${el}${id}${u.classAttr(node) || u.classAttr(node.parent)}>`);
          },
          exit({ node }) {
            c.append(`</h${level(node)}>`);
          },
        };
      }
      return this;
    },

    enter() {
      c.defer();
    },

    exit({ node }) {
      const chapter = node.chapter;
      const short = evalShortChapterHeading(chapter);
      chapter.setMetaData(`shortChapterHeading`, short);
      c.fulfillDeferred(`<header class="chapter-heading" data-short="${short}">`);
      c.push(`</header>`);
    },
  },

  headingSequenceIdentifier: {
    enter({ node }) {
      const el = isChapter(node.parent) ? `h2` : `span`;
      const kind = node.getMetaData(`kind`);
      const roman = node.getMetaData(`roman`);
      const sequenceNumber = node.expectNumberMetaData(`number`);
      node.chapter.setMetaData(`sequenceNumber`, sequenceNumber);

      if (node.isOnlyChild()) {
        c.push(`<${el}>${kind} ${roman}</${el}>`);
        return;
      }

      const kls = `chapter-heading__sequence`;
      c.push(`<${el} class="${kls}">`);
      c.push(`${kind} <span class="${kls}__number">${roman}</span>`);
      c.push(`</${el}>`);
    },
  },

  headingTitle: {
    enter({ node }) {
      if (!isChapter(node.parent)) {
        return;
      }
      if (node.isFirstChild()) {
        c.push(`<h2>`);
      } else {
        c.push(`<div class="chapter-heading__title">`);
      }
    },

    exit({ node }) {
      if (!isChapter(node.parent)) {
        return;
      }
      if (node.isFirstChild()) {
        c.push(`</h2>`);
      } else {
        c.push(`</div>`);
      }
    },
  },
};

export default HeadingVisitor;

function level(node: AstNode): number {
  const headingLevel = node.meta?.level;
  if (typeof headingLevel === `undefined`) {
    node.print();
    throw new Error(`Unexpected missing level for heading node`);
  }
  return headingLevel;
}

function isChapter(node: AstNode): boolean {
  return level(node) === 2;
}
