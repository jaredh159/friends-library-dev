import prettier from 'prettier';

export default function prettify(path: string, code: string | Buffer): string | Buffer {
  if (typeof code !== `string`) {
    return code;
  }

  let prettified = code;
  if (path.endsWith(`.html`) || path.endsWith(`.xhtml`)) {
    prettified = prettier.format(prettified, {
      parser: `html`,
      htmlWhitespaceSensitivity: `strict`,
    });
  } else if (path.endsWith(`.css`)) {
    prettified = prettier.format(prettified, { parser: `css` });
    prettified = prettified
      .replace(/^};$/gm, `}`)
      .replace(/@page: ([^ ]+)\{/gm, `@page:$1 {`);
  }
  return prettified;
}
