import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line === `` || !line.includes(`undefined`)) {
    return [];
  }

  const column = line.indexOf(`undefined`) + 1;

  return [
    {
      line: lineNumber,
      column,
      type: `error`,
      rule: rule.slug,
      message: `\`undefined\` is usually a scripting error artifact and should be removed`,
      fixable: false,
    },
  ];
};

rule.slug = `no-undefined`;
export default rule;
