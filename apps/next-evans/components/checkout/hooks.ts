import { useState, useEffect } from 'react';
import CartStore from './services/CartStore';

const store = CartStore.getSingleton();

export function useNumCartItems(): [number, (numItems: number) => void, CartStore] {
  const [numItems, setNumItems] = useState<number>(0);
  const onChange = (): void => setNumItems(store.cart.numItems());
  useEffect(() => {
    // prevent client hydration mismatch from reading cookie on first render
    setNumItems(store.cart.numItems());
    store.on(`cart:changed`, onChange);
    return () => {
      store.off(`cart:changed`, onChange);
    };
  }, []);
  return [numItems, setNumItems, store];
}

export function useCartTotalQuantity(): [number, (qty: number) => void, CartStore] {
  const [quantity, setQuantity] = useState<number>(store.cart.totalQuantity());
  const onChange = (): void => setQuantity(store.cart.totalQuantity());
  useEffect(() => {
    store.on(`cart:changed`, onChange);
    return () => {
      store.off(`cart:changed`, onChange);
    };
  }, []);
  return [quantity, setQuantity, store];
}
