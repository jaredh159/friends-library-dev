import { LineRule, LintResult } from '../types';
import { isAsciidocBracketLine } from '../utils';

const rule: LineRule = (
  line: string,
  lines: string[],
  lineNumber: number,
): LintResult[] => {
  if (line === `` || !line.includes(`_`) || isAsciidocBracketLine(line)) {
    return [];
  }

  const match = line.match(/[^_ \n+#([`]_[a-zA-Z]/);
  if (!match) {
    return [];
  }

  const column = (match.index || 0) + 2;
  const restOfLine = line.substring(column);

  // don't flag italicizing within a word like `sun_light_`
  if (restOfLine.match(/[a-z0-9:]+_/)) {
    return [];
  }

  // don't flag xrefs
  if (restOfLine.match(/^src,/) && line.includes(`__xref_src`)) {
    return [];
  }

  return [
    {
      line: lineNumber,
      column,
      type: `error`,
      rule: rule.slug,
      message: `Unexpected underscore`,
    },
  ];
};

rule.slug = `unexpected-underscore`;
export default rule;
