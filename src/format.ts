import prettier from 'prettier';
import env from '@friends-library/env';
import { red } from 'x-chalk';

export default function format(path: string, code: string | Buffer): string | Buffer {
  if (typeof code !== `string`) {
    return code;
  }

  try {
    let formatted = code;
    if (path.endsWith(`.html`) || path.endsWith(`.xhtml`)) {
      formatted = prettier.format(formatted, {
        parser: `html`,
        htmlWhitespaceSensitivity: `strict`,
      });
    } else if (path.endsWith(`.css`)) {
      formatted = prettier.format(formatted, { parser: `css` });
      formatted = formatted
        .replace(/^};$/gm, `}`)
        .replace(/@page: ([^ ]+)\{/gm, `@page:$1 {`);
    }
    return formatted;
  } catch (err) {
    if (env.truthy(`DEBUG_ARTIFACT_SRC`)) {
      console.log(String(err));
      red(`Error formatting cource code at ${path}, using un-formatted source instead`);
      return code;
    } else {
      red(
        `Error formatting source code at ${path}, set DEBUG_ARTIFACT_SRC=true to bypass error and proceed with incorrect and unformatted source code`,
      );
      throw err;
    }
  }
}
