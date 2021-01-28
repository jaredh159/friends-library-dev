import { Visitable, AstNode, VisitData } from '@friends-library/parser';
import { utils as u, classAttr, chapterMarkup as c } from '../utils';

export default class AttributedQuoteBlockVisitor implements Visitable {
  public enter({ node }: VisitData): void {
    const classList = node.context?.classList ?? [];
    c.push(`<figure${classAttr(node, [`attributed-quote`])}>`);
    c.push(`<blockquote${classAttr(node, classList)}>`);
  }

  public exit({ node }: VisitData): void {
    const cite = u.joinTokens(node.context?.quoteSource ?? []);
    const attribution = getAttribution(node);
    c.push(`</blockquote>`);
    c.push(`<figcaption>${attribution}<cite>${cite}</cite></figcaption>`);
    c.push(`</figure>`);
  }
}

function getAttribution(node: AstNode): string {
  if (node.context?.quoteAttribution?.length) {
    const src = u.joinTokens(node.context.quoteAttribution);
    return `<span class="quote-attribution">&#8212; ${src}</span>`;
  }
  return ``;
}
