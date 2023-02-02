import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line[0] !== `[` || line[line.length - 1] !== `]`) {
    return [];
  }

  if (!line.startsWith(`[.book-title]`)) {
    return [];
  }

  return [
    {
      line: lineNumber,
      column: false,
      type: `error`,
      rule: rule.slug,
      message: `Line-ending bracket needs to be escaped because the line starts with a [.book-title]`,
      recommendation: line.replace(/\]$/, `+++]+++`),
    },
  ];
};

rule.slug = `confusing-bracket`;
export default rule;
