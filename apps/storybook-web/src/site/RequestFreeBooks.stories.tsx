import React from 'react';
import { action as a } from '@storybook/addon-actions';
import { RequestFreeBooks } from '@evans/RequestFreeBooks';
import { useAddress } from '@evans/lib/hooks';
import type { Meta } from '@storybook/react';

export default {
  title: 'Site/Misc/RequestFreeBooks', // eslint-disable-line
  parameters: { layout: `fullscreen` },
} as Meta;

export const Submitting = () => <RequestFreeBooks state="submitting" />;

export const SubmitSuccess = () => (
  <RequestFreeBooks state="submit_success" onClose={a(`close`)} initialTitles="" />
);

export const SubmitError = () => (
  <RequestFreeBooks
    state="submit_error"
    onRetry={a(`retry`)}
    onClose={a(`close`)}
    initialTitles=""
  />
);

export const Default = () => {
  const [addressProps, , addressValid] = useAddress({});
  return (
    <RequestFreeBooks
      addressProps={addressProps}
      addressIsValid={addressValid}
      state="default"
      initialTitles="La Senda Antigua — John Griffith"
      onSubmit={a(`submit`)}
      onClose={a(`close`)}
    />
  );
};
