import { Visitor, NODE as n, VisitorEvent, VisitFn } from '@friends-library/parser';
import {
  symbolOutput,
  joinTokens,
  chapterMarkup as c,
  classAttr,
  consumeClasses,
  wrap,
} from '../utils';
import BlockVisitor from './BlockVisitor';

type Output = Array<string[]>;

const listeners: { [k in VisitorEvent]?: Array<VisitFn<Output>> } = {};

const visitor: Visitor<Output> = {
  on: (event, listener) => {
    if (listeners[event]) {
      (listeners[event] ?? []).push(listener);
    } else {
      listeners[event] = [listener];
    }
  },
  off: (event, listener) => {
    const eventListeners = listeners[event] ?? [];
    const fnIndex = eventListeners.indexOf(listener);
    if (fnIndex > -1) {
      eventListeners.splice(fnIndex, 1);
    }
  },
  emit: (event, data) => {
    const eventListeners = listeners[event] ?? [];
    eventListeners.forEach((listener) => listener(data));
  },
};

visitor.chapter = {
  enter({ node, output, index }) {
    c.reset();
    output.push(c.get());
    const { context } = node;
    const classes = [`chapter`, `chapter-${index + 1}`, ...consumeClasses(node)];
    const attrs = context?.shortTitle
      ? ` data-short-title="${joinTokens(context.shortTitle)}"`
      : ``;
    const id = context?.id ? ` id="${context.id}"` : ` `;
    c.push(`<div${id}class="${classes.join(` `)}"${attrs}>`);
  },
  exit() {
    c.push(`</div>`);
  },
};

visitor.heading = {
  enter({ node }) {
    c.push(`<h${node.meta.level ?? 1}${classAttr(node) || classAttr(node.parent)}>`);
  },
  exit({ node }) {
    c.push(`</h${node.meta.level ?? 1}>`);
  },
};

visitor.block = new BlockVisitor(visitor);

visitor.symbol = {
  enter({ node }) {
    c.append(symbolOutput(node));
  },
};

visitor.paragraph = {
  enter({ node }) {
    const parent = node.parent;
    if (parent.type !== n.FOOTNOTE) {
      c.push(`<p${classAttr(parent) || classAttr(node)}>`);
    } else if (parent.children.length > 1) {
      c.push(`<span class="footnote-paragraph">`);
    }
  },
  exit({ node }) {
    if (node.parent.type !== n.FOOTNOTE) {
      c.push(`</p>`);
    } else if (node.parent.children.length > 1) {
      c.push(`</span>`);
    }
  },
};

visitor.thematicBreak = {
  enter({ node }) {
    if (node.context?.classList.includes(`asterism`)) {
      c.push(`<div class="asterism">*&#160;&#160;*&#160;&#160;*</div>`);
    }
  },
};

visitor.footnote = {
  enter() {
    c.push(`<span class="footnote">`);
  },
  exit() {
    c.push(`</span>`);
  },
};

visitor.text = {
  enter({ node }) {
    c.append(node.value);
  },
};

visitor.unorderedList = wrap(`ul`);
visitor.listItem = wrap(`li`);
visitor.emphasis = wrap(`em`);
visitor.oldStyleLine = wrap(`span`);
visitor.descriptionList = wrap(`dl`);
visitor.descriptionListItemTerm = wrap(`dt`);
visitor.descriptionListItemContent = wrap(`dd`);

export default visitor;
