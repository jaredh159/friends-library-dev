import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line === ``) {
    return [];
  }

  if (!line.match(/^Postscript.?$/i)) {
    return [];
  }

  return [
    {
      line: lineNumber,
      column: false,
      type: `error`,
      rule: rule.slug,
      message: `Postscript "headers" are not allowed`,
      recommendation: `Add \`Postscript.--\` to start of postscript body`,
      fixable: false,
    },
  ];
};

rule.slug = `postscript-header`;

export default rule;
