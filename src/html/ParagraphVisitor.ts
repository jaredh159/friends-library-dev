import { Visitable, AstNode, VisitData } from '@friends-library/parser';
import { utils as u, chapterMarkup as c } from '../utils';

export default class ParagraphVisitor implements Visitable {
  enter({ node }: VisitData): void {
    const el = isChapterSubtitleBlurb(node) ? `h3` : `p`;
    if (opensNumberedSubgroup(node)) {
      c.push(`<div${u.classAttr(node)}>`);
    }
    // let classAttr = u.classAttr(node) || u.classAttr(node.parent);
    // if (el === `p` && classAttr === ``) {
    //   classAttr = ` class="paragraph"`;
    // }
    c.push(`<${el}${classAttr(el, node)}>`);
  }

  exit({ node }: VisitData): void {
    const el = isChapterSubtitleBlurb(node) ? `h3` : `p`;
    c.push(`</${el}>`);
    if (closesNumberedSubgroup(node)) {
      c.push(`</div>`);
    }
  }
}

function opensNumberedSubgroup(node: AstNode): boolean {
  return node.hasClass(`numbered`);
}

function closesNumberedSubgroup(node: AstNode): boolean {
  return !!(
    node.parent.hasClass(`numbered-group`) &&
    (node.isLastChild() || node.nextSibling()?.hasClass('numbered'))
  );
}

function isChapterSubtitleBlurb(node: AstNode): boolean {
  return (
    node.hasClass(`chapter-subtitle--blurb`) ||
    node.parent.hasClass(`chapter-subtitle--blurb`)
  );
}

function classAttr(el: 'p' | 'h3', node: AstNode): string {
  let htmlAttr = u.classAttr(node) || u.classAttr(node.parent);
  if (el === `h3`) {
    return htmlAttr;
  }

  if (htmlAttr === ``) {
    htmlAttr = ` class="paragraph"`;
  } else if (htmlAttr.includes('emphasized')) {
    htmlAttr = htmlAttr.replace(`class="`, `class="paragraph `);
  }
  return htmlAttr;
}
