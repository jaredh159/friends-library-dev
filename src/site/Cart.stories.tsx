import React, { useState } from 'react';
import { Meta } from '@storybook/react';
import { action as a } from '@storybook/addon-actions';
import { WebCoverStyles } from '../decorators';
import CartModel from '@evans/checkout/models/Cart';
import CartComponent from '@evans/cart';
import CartItemComponent from '@evans/cart/Item';
import { cartItemsData, cartItemData3 } from '@evans/checkout/models/__tests__/fixtures';
import CartItemModel, { CartItemData } from '@evans/checkout/models/CartItem';

export default {
  title: `Site/Checkout/Cart`,
  decorators: [WebCoverStyles],
} as Meta;

export const Cart = () => <StatefulCart />;
export const CartItem = () => <StatefulCartItem />;

const StatefulCart: React.FC = () => {
  const cart = CartModel.fromJson({ items: [...cartItemsData(), cartItemData3()] });
  const [items, setItems] = useState<CartItemData[]>(cart.items.map((i) => i.toJSON()));
  return (
    <CartComponent
      subTotal={cart.subTotal()}
      items={items}
      setItems={(items) => {
        cart.items = items.map((i) => new CartItemModel(i));
        setItems(items);
      }}
      checkout={a(`checkout`)}
      onContinueBrowsing={a(`continue browsing`)}
    />
  );
};

const StatefulCartItem: React.FC = () => {
  const [qty, setQty] = useState<number>(1);
  const data = cartItemData3();
  return (
    <CartItemComponent
      edition="updated"
      displayTitle={data.displayTitle}
      title={data.title}
      author={data.author}
      quantity={qty}
      price={422}
      changeQty={setQty}
      remove={a(`remove`)}
    />
  );
};
