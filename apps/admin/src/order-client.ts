import { v4 as uuid } from 'uuid';
import OrderClient, { type T } from '@friends-library/pairql/order';
import type { OrderItem } from './types';
import * as price from './lib/price';

const client = OrderClient.web(
  window.location.href,
  () => localStorage.getItem(`token`) ?? undefined,
);

export default client;

export { T };

export async function createOrder(
  address: T.ShippingAddress,
  items: OrderItem[],
  email: string,
  requestId: UUID,
): Promise<UUID | Error> {
  const metaRes = await client.getPrintJobExploratoryMetadata({
    address,
    email,
    items,
  });
  if (!metaRes.isSuccess) {
    return Error(`Error getting print job metadata: ${metaRes.error}`);
  }

  const { shipping, taxes, fees, shippingLevel } = metaRes.unwrap();

  const totalCents = price.subtotal(items) + shipping + taxes + fees;
  const total = price.formatted(totalCents);
  if (!confirm(`Grand total (w/ shipping and taxes) is ${total}. Proceed?`)) {
    return Error(`User cancelled`);
  }

  const createOrderInput: T.CreateOrder.Input = {
    lang: items.some((i) => i.lang === `es`) ? `es` : `en`,
    email,
    source: `internal`,
    addressCity: address.city,
    addressCountry: address.country,
    addressName: address.name,
    addressState: address.state,
    addressStreet: address.street,
    addressStreet2: address.street2,
    addressZip: address.zip,
    amount: totalCents,
    shipping,
    taxes,
    fees,
    ccFeeOffset: 0, // it's our own credit card, so no need to offset
    shippingLevel,
    freeOrderRequestId: requestId.trim() || undefined,
    paymentId: `internal--complimentary--${uuid().split(`-`).shift()}`,
    items: items.map((item) => {
      const inputItem: T.CreateOrder.Input['items'][number] = {
        editionId: item.editionId,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
      };
      return inputItem;
    }),
  };

  const result = await client.createOrder(createOrderInput);
  return result.reduce<UUID | Error>({
    success: (id) => id,
    error: (err) => Error(`Error creating order: ${err}`),
  });
}

export async function isAddressValid(
  address: T.ShippingAddress,
): Promise<Error | undefined> {
  const metadataResult = await client.getPrintJobExploratoryMetadata({
    address,
    email: `you@example.com`,
    items: [{ volumes: [100], printSize: `m`, quantity: 1 }],
  });
  if (!metadataResult.isSuccess) {
    return Error(
      `Error getting print job metadata: ${JSON.stringify(metadataResult.error)}`,
    );
  }
  return undefined;
}
