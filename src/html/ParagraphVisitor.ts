import { Visitable, AstNode, VisitData } from '@friends-library/parser';
import { utils as u, chapterMarkup as c } from '../utils';

export default class ParagraphVisitor implements Visitable {
  enter({ node }: VisitData): void {
    if (opensNumberedSubgroup(node)) {
      c.push(`<div${u.classAttr(node)}>`);
    }
    c.push(`<p${u.classAttr(node) || u.classAttr(node.parent)}>`);
  }

  exit({ node }: VisitData): void {
    c.push(`</p>`);
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
