import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line === `` || line.length < 4) {
    return [];
  }

  if (line[line.length - 3] !== ` `) {
    return [];
  }

  if (!line.match(/ ("`|`"|'`|`')$/)) {
    return [];
  }

  return [
    {
      line: lineNumber,
      column: line.length - 1,
      type: `error`,
      rule: rule.slug,
      message: `Invalid hanging quotation. Perhaps move it to the next line?`,
    },
  ];
};

rule.slug = `hanging-quotes`;
export default rule;
