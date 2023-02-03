export function replaceVars(css: string, vars: Record<string, string>): string {
  return css.replace(/var\((--[^)]+)\)/g, (_, varId) => {
    return vars[varId] || ``;
  });
}
