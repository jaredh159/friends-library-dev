import React from 'react';
import { Meta } from '@storybook/react';
import { action as a } from '@storybook/addon-actions';
import { WebCoverStyles } from '../decorators';
import Modal from '@evans/checkout/Modal';
import CheckoutMachine from '@evans/checkout/services/CheckoutMachine';
import CheckoutService from '@evans/checkout/services/CheckoutService';
import CheckoutFlow from '@evans/checkout/Flow';
import { cartPlusData, cart } from '@evans/checkout/models/__tests__/fixtures';
import MockCheckoutApi from '../MockCheckoutApi';

export default {
  title: `Site/Checkout/Flow`,
  decorators: [WebCoverStyles],
} as Meta;

export const Prefilled = () => (
  <Modal onClose={a(`close modal`)}>
    <CheckoutFlow machine={machine()} recommendedBooks={[]} />
  </Modal>
);

export const NotPrefilled = () => (
  <Modal onClose={a(`close modal`)}>
    <CheckoutFlow machine={machine(cart())} recommendedBooks={[]} />
  </Modal>
);

export const ShippingImpossible = () => {
  const api = new MockCheckoutApi(1000);
  api.responses.getExploratoryMetadata.push({ status: `shipping_not_possible` });
  const service = new CheckoutService(cartPlusData(), api);
  const machine = new CheckoutMachine(service);
  return (
    <Modal onClose={a(`close modal`)}>
      <CheckoutFlow machine={machine} recommendedBooks={[]} />
    </Modal>
  );
};

export const CreateOrderFail = () => {
  const api = new MockCheckoutApi(1000);
  api.responses.createOrder.push(false);
  const service = new CheckoutService(cartPlusData(), api);
  const machine = new CheckoutMachine(service);
  return (
    <Modal onClose={a(`close modal`)}>
      <CheckoutFlow machine={machine} recommendedBooks={[]} />
    </Modal>
  );
};

function machine(cart: any = cartPlusData()): CheckoutMachine {
  const service = new CheckoutService(cart, new MockCheckoutApi(1000));
  return new CheckoutMachine(service);
}
