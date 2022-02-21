import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line === ``) {
    return [];
  }

  if (line.includes(`{footnote-paragraph-split}`) && lines[lineNumber] === ``) {
    return [
      {
        line: lineNumber + 1,
        column: 1,
        type: `error`,
        rule: rule.slug,
        message: `footnote paragraph splits must not be followed by empty lines`,
        fixable: true,
        recommendation: `<-- remove line ${lineNumber + 1}`,
      },
    ];
  }

  return [];
};

rule.slug = `footnote-split-spacing`;
export default rule;
