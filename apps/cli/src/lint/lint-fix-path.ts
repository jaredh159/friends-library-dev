import fs from 'fs';
import { lintFix } from '@friends-library/adoc-lint';
import type { LintOptions } from '@friends-library/adoc-lint';
import type DirLints from './DirLints';
import lintPath from './lint-path';
import { langFromPath, editionTypeFromPath } from './path';

export default function lintFixPath(
  path: string,
  options: LintOptions = { lang: `en` },
): { unfixable: DirLints; numFixed: number } {
  const lints = lintPath(path, options);
  const fixable = lints.numFixable();
  if (fixable === 0) {
    return { unfixable: lints, numFixed: 0 };
  }

  lints.toArray().forEach(([filepath, { adoc }]) => {
    const { fixed } = lintFix(adoc, {
      ...options,
      lang: langFromPath(filepath),
      editionType: editionTypeFromPath(filepath),
    });
    fs.writeFileSync(filepath, fixed);
  });

  return {
    unfixable: lintPath(path, options),
    numFixed: fixable,
  };
}
