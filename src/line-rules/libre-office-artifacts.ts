import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line === `` || !line.includes(`++++++`)) {
    return [];
  }

  const regex = /\+{3}\[\+{6}\[\+{3}(\w|\.)+\]\]/;
  const match = line.match(regex);
  if (!match) {
    return [];
  }

  return [
    {
      line: lineNumber,
      column: match.index ? match.index + 1 : 0,
      type: `error`,
      rule: rule.slug,
      message: `Libre Office ref artifacts must be removed`,
      fixable: true,
      recommendation: line.replace(regex, ``),
    },
  ];
};

rule.slug = `libre-office-artifacts`;
export default rule;
