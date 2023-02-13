import { lint } from '@friends-library/adoc-lint';
import type { LintOptions } from '@friends-library/adoc-lint';
import DirLints from './DirLints';
import { filesFromPath, langFromPath, editionTypeFromPath } from './path';

export default function lintPath(
  path: string,
  options: LintOptions = { lang: `en` },
): DirLints {
  const files = filesFromPath(path);
  const lints = new DirLints();
  files.forEach((file) =>
    lints.set(file.path, {
      lints: lint(file.adoc, {
        ...options,
        lang: langFromPath(file.path),
        editionType: editionTypeFromPath(file.path),
      }),
      adoc: file.adoc,
    }),
  );
  return lints;
}
