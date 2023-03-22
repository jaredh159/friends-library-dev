import React from 'react';
import AudiobookComponent from '@evans/pages/audiobooks/Audiobook';
import type { Meta } from '@storybook/react';
import { props as coverProps } from '../cover-helpers';
import { WebCoverStyles } from '../decorators';

export default {
  title: 'Site/Pages/Audiobooks', // eslint-disable-line
  component: AudiobookComponent,
  decorators: [WebCoverStyles],
} as Meta;

export const Audiobook = () => (
  <AudiobookComponent
    {...coverProps}
    bgColor="blue"
    duration="45:00"
    documentUrl="/"
    authorUrl="/"
    description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo."
  />
);
