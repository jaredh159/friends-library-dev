import React from 'react';
import { ThreeD } from '@friends-library/cover-component';
import { StripeProvider, Elements } from 'react-stripe-elements';
import Delivery from '@evans/checkout/Delivery';
import Payment from '@evans/checkout/Payment';
import Input from '@evans/checkout/Input';
import EmptyCart from '@evans/checkout/EmptyCart';
import UnrecoverableError from '@evans/checkout/UnrecoverableError';
import Progress from '@evans/checkout/Progress';
import Confirmation from '@evans/checkout/Confirmation';
import type { Meta } from '@storybook/react';
import { WebCoverStyles } from '../decorators';
import { props as coverProps } from '../cover-helpers';

export default {
  title: 'Site/Checkout/Components', // eslint-disable-line
  parameters: { layout: `centered` },
  decorators: [
    WebCoverStyles,
    (Story) => (
      <div className="max-w-screen-lg">
        <Story />
      </div>
    ),
  ],
} as Meta;

export const Empty_Cart = () => (
  <EmptyCart
    recommendedBooks={[
      {
        title: `No Cross, No Crown`,
        Cover: <ThreeD {...coverProps} scaler={0.25} scope="1-4" />,
      },
      {
        title: `Journal of George Fox`,
        Cover: <ThreeD {...coverProps} edition="modernized" scaler={0.25} scope="1-4" />,
      },
      {
        title: `The Work of Vital Religion in the Soul`,
        Cover: <ThreeD {...coverProps} edition="original" scaler={0.25} scope="1-4" />,
      },
    ].map((b) => ({ ...b, path: `/` }))}
  />
);

export const Payment_ = () => (
  <StripeProvider apiKey="pk_test_DAZbsOWXXbvBe51IEVvVfc4H">
    <Elements>
      <Payment
        throbbing={false}
        onPay={() => {}}
        onBack={() => {}}
        subTotal={1298}
        shipping={399}
        taxes={132}
        ccFeeOffset={42}
        handling={150}
        paymentIntentClientSecret="pi_123_secret_345"
      />
    </Elements>
  </StripeProvider>
);

export const PaymentThrobbing = () => (
  <StripeProvider apiKey="pk_test_DAZbsOWXXbvBe51IEVvVfc4H">
    <Elements>
      <Payment
        throbbing={true}
        onPay={() => {}}
        onBack={() => {}}
        subTotal={1298}
        shipping={399}
        taxes={132}
        ccFeeOffset={42}
        handling={150}
        paymentIntentClientSecret="pi_123_secret_345"
      />
    </Elements>
  </StripeProvider>
);

export const ProgressOrder = () => <Progress step="Order" />;
export const ProgressDelivery = () => <Progress step="Delivery" />;
export const ProgressPayment = () => <Progress step="Payment" />;
export const ProgressConfirmation = () => <Progress step="Confirmation" />;

export const InputValid = () => (
  <div style={{ width: 300 }}>
    <Input
      valid={true}
      onChange={() => {}}
      placeholder="Credit Card #"
      invalidMsg="Invalid Credit Card Number"
    />
  </div>
);

export const InputInvalid = () => (
  <div style={{ width: 300 }}>
    <Input
      valid={false}
      onChange={() => {}}
      placeholder="Credit Card #"
      invalidMsg="Invalid Credit Card Number"
    />
  </div>
);

export const InputInvalidValue = () => (
  <div style={{ width: 300 }}>
    <Input
      valid={false}
      onChange={() => {}}
      placeholder="Credit Card #"
      value="444"
      invalidMsg="Invalid Credit Card Number"
    />
  </div>
);

export const Confirmation_ = () => (
  <Confirmation email="you@example.com" onClose={() => {}} />
);

export const Delivery_ = () => <Delivery onBack={() => {}} onSubmit={() => {}} />;

export const DeliveryError = () => (
  <Delivery error onBack={() => {}} onSubmit={() => {}} />
);

export const DeliveryThrobbing = () => (
  <Delivery throbbing onBack={() => {}} onSubmit={() => {}} />
);

export const UnrecoverableError_ = () => (
  <UnrecoverableError onClose={() => {}} onRetry={() => {}} />
);
