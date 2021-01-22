import { DocPrecursor } from '@friends-library/types';
import { Visitor, AstNode } from '@friends-library/parser';

type Output = string[];
type Context = { dpc: DocPrecursor };
type Data = { node: AstNode; output: Output; context: Context };

const visitor: Visitor<Output, Context> = {
  document: {
    enter({ output, context }) {
      output.push(context.dpc.meta.title.toUpperCase());
      output.push(``);
      output.push(`by ${context.dpc.meta.author.name.toUpperCase()}`);
      output.push(``);
      output.push(``);
    },
  },
  paragraph: {
    enter: pushLine,
  },
  heading: {
    enter: pushLine,
    exit: pushLine,
  },
  node: {
    enter: appendValue,
  },
  // node: {
  //   enter({ node, output }) {
  //     output.push(`NODE: ${node.type}`);
  //   },
  // },
};

export default visitor;

function pushLine({ output }: Data): void {
  output.push(``);
}

function appendValue({ node, output }: Data): void {
  let line = output.pop() ?? ``;
  line += node.value;
  output.push(line);
}
