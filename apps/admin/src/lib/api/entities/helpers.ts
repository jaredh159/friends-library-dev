export function isClientGeneratedId(id: unknown): boolean {
  return !!(typeof id === `string` && id.match(MATCH_CLIENT_GENERATED_ID));
}

export function removeClientGeneratedIdPrefix(id: string): string {
  return id.replace(/^_/, ``);
}

const MATCH_CLIENT_GENERATED_ID =
  /^_[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i;
