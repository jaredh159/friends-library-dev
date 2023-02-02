export function money(amt: number): string {
  return `$${(amt / 100).toFixed(2)}`;
}
