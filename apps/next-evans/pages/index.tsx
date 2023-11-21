import React from 'react';
import { t } from '@friends-library/locale';
import Client, { type T as Api } from '@friends-library/pairql/next-evans-build';
import type { GetStaticProps } from 'next';
import type { FeedItem } from '@/components/pages/home/news-feed/news-feed';
import { getNewsFeedItems } from '@/components/pages/home/news-feed/news-feed';
import FeaturedBooksBlock from '@/components/pages/home/FeaturedBooksBlock';
import HeroBlock from '@/components/pages/home/HeroBlock';
import SubHeroBlock from '@/components/pages/home/SubHeroBlock';
import GettingStartedBlock from '@/components/pages/home/GettingStartedBlock';
import WhoWereTheQuakersBlock from '@/components/pages/home/WhoWereTheQuakersBlock';
import FormatsBlock from '@/components/pages/home/FormatsBlock';
import ExploreBooksBlock from '@/components/pages/home/ExploreBooksBlock';
import NewsFeedBlock from '@/components/pages/home/news-feed/NewsFeedBlock';
import { LANG } from '@/lib/env';
import Seo, { pageMetaDesc } from '@/components/core/Seo';
import * as custom from '@/lib/ssg/custom-code';

export const getStaticProps: GetStaticProps<Props> = async () => {
  const client = Client.node(process);
  const props = await Promise.all([
    client.homepageFeaturedBooks({ lang: LANG, slugs: featuredBooks[LANG] }),
    client.newsFeedItems(LANG),
    client.totalPublished(),
    custom.some(featuredBooks[LANG]),
  ]).then(([featuredBooks, newsFeedItems, totalPublished, customCode]) => ({
    featuredBooks: featuredBooks.map((book) => {
      const coverCode = customCode[`${book.authorSlug}/${book.documentSlug}`];
      return coverCode ? custom.merge(book, coverCode) : book;
    }),
    newsFeedItems: getNewsFeedItems(newsFeedItems),
    numTotalBooks: totalPublished.books[LANG],
  }));
  return { props };
};

interface Props {
  featuredBooks: Api.HomepageFeaturedBooks.Output;
  newsFeedItems: FeedItem[];
  numTotalBooks: number;
}

const Home: React.FC<Props> = ({ featuredBooks, newsFeedItems, numTotalBooks }) => (
  <main className="overflow-hidden">
    <Seo
      title={t`Friends Library`}
      description={pageMetaDesc(`home`, { numBooks: numTotalBooks })}
    />
    <HeroBlock />
    <SubHeroBlock numTotalBooks={numTotalBooks} />
    <NewsFeedBlock items={newsFeedItems} />
    <FeaturedBooksBlock books={featuredBooks} />
    <GettingStartedBlock />
    <WhoWereTheQuakersBlock />
    <FormatsBlock />
    <ExploreBooksBlock numTotalBooks={numTotalBooks} />
  </main>
);

export default Home;

// helpers

const featuredBooks = {
  en: [
    { friendSlug: `compilations`, documentSlug: `truth-in-the-inward-parts-v1` },
    { friendSlug: `hugh-turford`, documentSlug: `walk-in-the-spirit` },
    { friendSlug: `isaac-penington`, documentSlug: `writings-volume-1` },
    { friendSlug: `isaac-penington`, documentSlug: `writings-volume-2` },
    { friendSlug: `william-penn`, documentSlug: `no-cross-no-crown` },
    { friendSlug: `william-sewel`, documentSlug: `history-of-quakers` },
  ],
  es: [
    { friendSlug: `isaac-penington`, documentSlug: `escritos-volumen-1` },
    { friendSlug: `isaac-penington`, documentSlug: `escritos-volumen-2` },
    { friendSlug: `william-penn`, documentSlug: `no-cruz-no-corona` },
  ],
};
