import { Visitable, AstNode, VisitData, VisitFn, Visitor } from '@friends-library/parser';
import { utils as u, classAttr, chapterMarkup as c } from '../utils';

export default class BlockVisitor implements Visitable {
  private close: string[] = [];

  public constructor(protected visitor: Visitor<string[][]>) {}

  public enter({ node }: VisitData): unknown {
    if (node.isNumberedBlock()) {
      return this.enterNumberedBlock(node);
    }

    if (node.isExampleBlock() || node.isOpenBlock()) {
      c.push(`<div${classAttr(node)}>`);
      return this.close.push(`</div>`);
    }

    if (node.isAttributedQuoteBlock()) {
      return this.enterAttributedQuoteBlock(node);
    }

    if (node.isQuoteBlock()) {
      c.push(`<blockquote${classAttr(node)}>`);
      return this.close.push(`</blockquote>`);
    }
  }

  public beforeEnterParagraph: VisitFn = ({ node }) => {
    if (node.hasClass(`numbered`)) {
      c.push(`<div${classAttr(node)}>`);
    }
  };

  public afterExitParagraph: VisitFn = ({ node }) => {
    if (node.isLastChild() || node.nextSibling()?.hasClass(`numbered`)) {
      c.push(`</div>`);
    }
  };

  protected enterNumberedBlock(node: AstNode): void {
    c.push(`<div${classAttr(node)}>`);
    this.visitor.on?.(`beforeEnterParagraph`, this.beforeEnterParagraph);
    this.visitor.on?.(`afterExitParagraph`, this.afterExitParagraph);
  }

  protected enterAttributedQuoteBlock(node: AstNode): void {
    const classList = node.context?.classList ?? [];
    c.push(`<figure${classAttr(node, [`attributed-quote`])}>`);
    c.push(`<blockquote${classAttr(node, classList)}>`);
    const cite = u.joinTokens(node.context?.quoteSource ?? []);
    const attribution = getAttribution(node);
    this.close.push(`</blockquote>`);
    this.close.push(`<figcaption>${attribution}<cite>${cite}</cite></figcaption>`);
    this.close.push(`</figure>`);
    return;
  }

  public exit({ node }: VisitData): void {
    this.close.forEach((line) => c.push(line));
    this.close = [];

    if (node.isNumberedBlock()) {
      this.visitor.off?.(`beforeEnterParagraph`, this.beforeEnterParagraph);
      this.visitor.off?.(`afterExitParagraph`, this.afterExitParagraph);
      c.push(`</div>`);
    }
  }
}

function getAttribution(node: AstNode): string {
  if (node.context?.quoteAttribution?.length) {
    const src = u.joinTokens(node.context.quoteAttribution);
    return `<span class="quote-attribution">&#8212; ${src}</span>`;
  }
  return ``;
}
