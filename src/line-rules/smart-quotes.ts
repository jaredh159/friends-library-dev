import { quotifyLine } from '@friends-library/adoc-utils';
import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  const fixed = quotifyLine(line);
  if (fixed === line) {
    return [];
  }

  let column: number | null = null;
  line.split(``).forEach((char, col) => {
    if (column === null && char !== fixed[col]) {
      column = col;
    }
  });

  return [
    {
      line: lineNumber,
      type: `error`,
      column: column || 0,
      rule: rule.slug,
      message: `Incorrect usage of smart quotes/apostrophes`,
      recommendation: fixed,
      fixable: true,
    },
  ];
};

rule.slug = `smart-quotes`;
export default rule;
