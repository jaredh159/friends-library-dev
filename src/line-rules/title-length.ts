import { LineRule, LintOptions, LintResult } from '../types';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
  lintOptions: LintOptions,
): LintResult[] => {
  if (lintOptions.lang === `es` || line === `` || line[0] !== `=`) {
    return [];
  }

  if (line.length < 3 || line.substring(0, 3) !== `== `) {
    return [];
  }

  const prevLine = lines[lineNumber - 2];
  if (prevLine && prevLine.includes(`short="`)) {
    return [];
  }

  const tocTitle = line
    .replace(/^== /, ``)
    .replace(/ \/.*/, ``)
    .replace(/^(Chapter|Section|Capítulo|Sección) (\d+|[IVXL]+)\.?/, ``);

  if (tocTitle.length <= 50) {
    return [];
  }

  return [
    {
      line: lineNumber,
      column: 4,
      type: `error`,
      rule: rule.slug,
      message: `long chapter titles need a hand-crafted short title for table of contents and running headers`,
    },
  ];
};

rule.slug = `title-length`;

export default rule;
