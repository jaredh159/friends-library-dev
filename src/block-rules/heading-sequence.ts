import { Asciidoc, LintResult } from '@friends-library/types';
import { BlockRule } from '../types';

const rule: BlockRule = (block: Asciidoc): LintResult[] => {
  const lines = block.split(`\n`);

  const lints: LintResult[] = [];
  let level = 1;

  lines.forEach((line, idx) => {
    if (line === `` || line[0] !== `=`) {
      return;
    }

    const match = line.match(/^(={2,4}) /);
    if (!match) {
      return;
    }

    const newLevel = match[1].length;
    if (Math.abs(newLevel - level) > 1) {
      lints.push({
        line: idx + 1,
        column: false,
        type: `error`,
        rule: rule.slug,
        message: `No skipping heading levels (i.e., from == to ====)`,
      });
    } else {
      level = newLevel;
    }
  });

  return lints;
};

rule.slug = `heading-sequence`;

export default rule;
