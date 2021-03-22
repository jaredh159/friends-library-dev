import { Css } from '@friends-library/types';

export function replaceVars(css: Css, vars: Record<string, string>): Css {
  return css.replace(/var\((--[^)]+)\)/g, (_, varId) => {
    return vars[varId] || ``;
  });
}
