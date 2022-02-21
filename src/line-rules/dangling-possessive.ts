import { LineRule, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line === ``) {
    return [];
  }

  const nextLine = lines[lineNumber];
  if (!nextLine || nextLine[0] !== `s` || !line.match(/`'$/)) {
    return [];
  }

  if (!nextLine.match(/^s\b/)) {
    return [];
  }

  return [
    {
      line: lineNumber,
      column: line.length + 1,
      type: `error`,
      rule: rule.slug,
      message: `Possessive broken over two lines (probably by conversion process)`,
      recommendation: `${line}s\n${nextLine.replace(/^s/, ``).trim()}`,
      fixable: true,
    },
  ];
};

rule.slug = `dangling-possessive`;
export default rule;
