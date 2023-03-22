import React from 'react';
import HomeHeroBlock from '@evans/pages/home/HeroBlock';
import HomeFeaturedBooksBlock from '@evans/pages/home/FeaturedBooksBlock';
import HomeWhoWereTheQuakersBlock from '@evans/pages/home/WhoWereTheQuakersBlock';
import London from '@evans/images/london.jpg';
import type { Meta } from '@storybook/react';
import { WebCoverStyles } from '../decorators';
import { props as coverProps } from '../cover-helpers';

export default {
  title: 'Site/Pages/Home', // eslint-disable-line
  decorators: [WebCoverStyles],
  parameters: { layout: `fullscreen` },
} as Meta;

export const WhoWereQuakersBlock = () => (
  <HomeWhoWereTheQuakersBlock bgImg={{ aspectRatio: 1, src: London, srcSet: `` }} />
);

export const HomeHeroBlock_ = () => <HomeHeroBlock />;

export const FeaturedBooksBlock = () => (
  <HomeFeaturedBooksBlock
    books={[
      {
        ...coverProps,
        featuredDesc: `Samuel Fothergill was one of the most eminent ministers in the history of the Society of Friends, greatly loved and esteemed for the humility and purity of his life, as well as the authority and heart-tendering power of his ministry.`,
        documentUrl: `/`,
        authorUrl: `/`,
      },
      {
        ...coverProps,
        htmlShortTitle: `Jounal of Daniel Wheeler`,
        title: `Jounal of Daniel Wheeler`,
        author: `Daniel Wheeler`,
        edition: `modernized`,
        featuredDesc: `Samuel Fothergill was one of the most eminent ministers in the history of the Society of Friends, greatly loved and esteemed for the humility and purity of his life, as well as the authority and heart-tendering power of his ministry.`,
        documentUrl: `/`,
        authorUrl: `/`,
      },
      {
        ...coverProps,
        edition: `original`,
        title: `Jounal of George Fox`,
        author: `George Fox`,
        htmlShortTitle: `Jounal of George Fox`,
        featuredDesc: `Samuel Fothergill was one of the most eminent ministers in the history of the Society of Friends, greatly loved and esteemed for the humility and purity of his life, as well as the authority and heart-tendering power of his ministry.`,
        documentUrl: `/`,
        authorUrl: `/`,
      },
    ]}
  />
);
