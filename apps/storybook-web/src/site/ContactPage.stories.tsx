import React from 'react';
import ContactForm from '@evans/pages/contact/Form';
import ContactFormBlock from '@evans/pages/contact/FormBlock';
import Books from '@evans/images/Books7.jpg';
import type { Meta } from '@storybook/react';

export default {
  title: 'Site/Pages/Contact', // eslint-disable-line
  parameters: { layout: `fullscreen` },
} as Meta;

export const ContactForm_ = () => (
  <div className="max-w-screen-md">
    <ContactForm onSubmit={async () => true} />
  </div>
);

const books = { aspectRatio: 1, src: Books, srcSet: `` };

export const FormBlockSuccess = () => (
  <ContactFormBlock bgImg={books} onSubmit={delay(3000)} />
);

export const FormBlockError = () => (
  <ContactFormBlock bgImg={books} onSubmit={delay(3000, false)} />
);

function delay(delay: number, result = true): () => Promise<boolean> {
  return () =>
    new Promise((res) => {
      setTimeout(() => res(result), delay);
    });
}
