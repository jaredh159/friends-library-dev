import React from 'react';
import { Meta } from '@storybook/react';
import { props as coverProps } from '../cover-helpers';
import { WebCoverStyles } from '../decorators';
import PathBlock from '@evans/pages/getting-started/PathBlock';

export default {
  title: `Site/Pages/Getting Started`,
  decorators: [WebCoverStyles],
} as Meta;

export const PathBlock_ = () => (
  <PathBlock
    slug="spiritual-life"
    title="Spiritual Life"
    books={[...books]}
    color="blue"
  />
);

/* ------------------------------------------- */
/* -------------- UTILITIES ------------------ */
/* ------------------------------------------- */

const books = [
  {
    ...coverProps,
    title: `No Cross, No Crown`,
    author: `William Penn`,
    documentUrl: `/no-cross-no-crown`,
    authorUrl: `/`,
    hasAudio: true,
  },
  {
    ...coverProps,
    title: `The Journal of Charles Marshall`,
    author: `Charles Marshall`,
    documentUrl: `/charles-marshall/journal`,
    authorUrl: `/`,
    hasAudio: true,
  },
  {
    ...coverProps,
    title: `Life and Letters of Catherine Payton`,
    author: `Catherine Payton`,
    edition: `modernized` as const,
    documentUrl: `/catherine-payton/life-and-letters`,
    authorUrl: `/`,
    hasAudio: false,
  },
  {
    ...coverProps,
    documentUrl: `/`,
    authorUrl: `/`,
    hasAudio: true,
  },
];
