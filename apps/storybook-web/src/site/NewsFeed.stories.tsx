import React from 'react';
import { Meta } from '@storybook/react';
import NewsFeedIcon from '@evans/pages/home/news-feed/NewsFeedIcon';
import NewsFeedItem from '@evans/pages/home/news-feed/NewsFeedItem';
import NewsFeedYear from '@evans/pages/home/news-feed/NewsFeedYear';
import NewsFeed from '@evans/pages/home/news-feed/NewsFeed';
import NewsFeedBlock from '@evans/pages/home/news-feed/NewsFeedBlock';
import Books11 from '@evans/images/Books11.jpg';
import { bgImg, fullscreen, name, setBg } from '../decorators';

export default {
  title: `Site/Misc/NewsFeed`,
  parameters: { layout: `centered` },
} as Meta;

export const Icons = setBg(`#f1f1f1`, () => (
  <div className="p-4 rounded-md flex w-64 justify-around">
    <NewsFeedIcon type="book" />
    <NewsFeedIcon type="audiobook" />
    <NewsFeedIcon type="spanish_translation" />
    <NewsFeedIcon type="feature" />
    <NewsFeedIcon type="chapter" />
  </div>
));

export const NewsFeedItem_ = () => <NewsFeedItem {...ITEMS[0]} />;

export const NewsFeedYear_ = () => (
  <NewsFeedYear year="2020" items={ITEMS.filter((i) => i.year === `2020`)} />
);

export const NewsFeedOneYear = name(`NewsFeed (one year)`, () => (
  <NewsFeed items={ITEMS.filter((i) => i.year === `2020`)} />
));

export const NewsFeedTwoYears = name(`NewsFeed (two years)`, () => (
  <NewsFeed items={ITEMS} />
));

export const NewsFeedBlock_ = fullscreen(() => (
  <NewsFeedBlock bgImg={bgImg(Books11)} items={ITEMS} />
));

/* ------------------------------------------- */
/* -------------- UTILITIES ------------------ */
/* ------------------------------------------- */

const ITEMS = [
  {
    type: `book` as const,
    url: `/`,
    month: `Aug`,
    day: `10`,
    title: `The Journal of Jane Johnson`,
    description: `The Journal of Jane Johnson now available to download or purchase.`,
    year: `2020`,
  },
  {
    type: `audiobook` as const,
    url: `/`,
    month: `Jul`,
    day: `8`,
    title: `The Writings of Ambrose Rigge`,
    description: `The Writings of Ambrose Rigge now available in listening format.`,
    year: `2020`,
  },
  {
    type: `chapter` as const,
    url: `/`,
    month: `Jun`,
    day: `15`,
    title: `The Journal of Ann Branson &mdash; Chapter II (Spanish)`,
    description: `The Journal of Ann Banson Chapter II now available in Spanish.`,
    year: `2020`,
  },
  {
    type: `spanish_translation` as const,
    url: `/`,
    month: `May`,
    day: `7`,
    title: `The Goblet of Fire &mdash; Spanish Translation`,
    description: `Spanish translation now available on the Spanish Friends site!`,
    year: `2020`,
  },
  {
    type: `feature` as const,
    url: `/`,
    month: `Apr`,
    day: `2`,
    title: `Friends Library App`,
    description: `The Friends Library App for iPhone and Android is now available!`,
    year: `2020`,
  },
  {
    type: `book` as const,
    url: `/`,
    month: `Aug`,
    day: `10`,
    title: `The Journal of Jane Johnson`,
    description: `The Journal of Jane Johnson now available to download or purchase.`,
    year: `2019`,
  },
  {
    type: `audiobook` as const,
    url: `/`,
    month: `Jul`,
    day: `8`,
    title: `The Writings of Ambrose Rigge`,
    description: `The Writings of Ambrose Rigge now available in listening format.`,
    year: `2019`,
  },
];
