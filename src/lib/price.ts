import { OrderItem } from '../types';

export function subtotal(items: OrderItem[]): number {
  return items.reduce((acc, item) => acc + item.unitPrice * item.quantity, 0);
}

export function formatted(priceInCents: number): string {
  return formatter.format(priceInCents / 100);
}

const formatter = new Intl.NumberFormat(`en-US`, {
  style: `currency`,
  currency: `USD`,
});
