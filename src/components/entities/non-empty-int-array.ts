export function makeValidator(opts: { canBeNull: boolean }): (input: string) => boolean {
  return (input) => {
    if (opts.canBeNull && input.trim() === ``) {
      return true;
    }
    return parseFromString(input) !== null;
  };
}

export function makeUpdater(
  setStringValue: (value: string) => void,
  replaceWith: (value: unknown) => unknown,
): (value: string) => void {
  return (value) => {
    setStringValue(value);
    replaceWith(parseFromString(value));
  };
}

export function parseFromString(input: string): number[] | null {
  try {
    const parsed = JSON.parse(input);
    if (
      Array.isArray(parsed) &&
      parsed.length > 0 &&
      parsed.every((i) => typeof i === `number` && Number.isInteger(i))
    ) {
      return parsed;
    }
  } catch {
    // ¯\_(ツ)_/¯
  }
  return null;
}
