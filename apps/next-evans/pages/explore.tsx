import React from 'react';
import Client, { type T as Api } from '@friends-library/pairql/next-evans-build';
import type { GetStaticProps } from 'next';
import type { Period } from '@/lib/types';
import { LANG } from '@/lib/env';
import BackgroundImage from '@/components/core/BackgroundImage';
import Dual from '@/components/core/Dual';
import HeroImg from '@/public/images/explore-books.jpg';
import NavBlock from '@/components/pages/explore/NavBlock';
import UpdatedEditionsBlock from '@/components/pages/explore/UpdatedEditionsBlock';
import GettingStartedLinkBlock from '@/components/pages/explore/GettingStartedLinkBlock';
import AudioBooksBlock from '@/components/pages/explore/AudioBooksBlock';
import NewBooksBlock from '@/components/pages/explore/NewBooksBlock';
import ExploreRegionsBlock from '@/components/pages/explore/RegionBlock';
import TimelineBlock from '@/components/pages/explore/TimelineBlock';
import AltSiteBlock from '@/components/pages/explore/AltSiteBlock';
import SearchBlock from '@/components/pages/explore/SearchBlock';
import { getDocumentUrl, getFriendUrl } from '@/lib/friend';
import { newestFirst } from '@/lib/dates';
import { documentRegion, publishedYear } from '@/lib/document';

type Props = Api.ExplorePage.Output;

export const getStaticProps: GetStaticProps<Props> = async () => {
  const props = await Client.node(process).explorePage(LANG);
  return { props };
};

const ExploreBooks: React.FC<Props> = ({ numTotalBooks, books }) => (
  <div>
    <BackgroundImage src={HeroImg} fineTuneImageStyles={{ objectFit: `cover` }}>
      <div className="p-8 sm:p-16 lg:p-24 bg-black/60 lg:backdrop-blur-sm">
        <WhiteOverlay>
          <Dual.H1 className="sans-wider text-3xl mb-6">
            <>Explore Books</>
            <>Explorar Libros</>
          </Dual.H1>
          <Dual.P className="body-text">
            <>
              We currently have {numTotalBooks[LANG]} books freely available on this site.
              Overwhelmed? On this page you can browse all the titles by edition, region,
              time period, tags, and more&mdash;or search the full library to find exactly
              what you’re looking for.
            </>
            <>
              Actualmente tenemos {numTotalBooks[LANG]} libros disponibles de forma
              gratuita en este sitio, y más están siendo traducidos y añadidos
              regularmente. En nuestra página de “Explorar” puedes navegar por todos
              nuestros libros y audiolibros, o buscar libros en la categoría particular
              que más te interese.
            </>
          </Dual.P>
        </WhiteOverlay>
      </div>
    </BackgroundImage>
    <NavBlock />
    <UpdatedEditionsBlock
      books={books
        .filter((book) => book.primaryEdition.type === `updated`)
        .sort(newestFirst)
        .map((book) => ({
          url: getDocumentUrl(book.friendSlug, book.slug),
          authorUrl: getFriendUrl(book.friendSlug, book.friendGender),
          isCompilation: book.isCompilation,
          editionType: book.primaryEdition.type,
          isbn: book.primaryEdition.isbn,
          title: book.title,
          authorName: book.friendName,
          authorSlug: book.friendSlug,
          customCss: book.customCss,
          customHtml: book.customHtml,
        }))}
    />
    <GettingStartedLinkBlock />
    <AudioBooksBlock
      books={books
        .filter((book) => book.hasAudio)
        .sort(newestFirst)
        .map((book) => ({
          url: getDocumentUrl(book.friendSlug, book.slug),
          isCompilation: book.isCompilation,
          editionType: book.primaryEdition.type,
          isbn: book.primaryEdition.isbn,
          title: book.title,
          htmlShortTitle: book.htmlShortTitle,
          authorName: book.friendName,
          authorSlug: book.friendSlug,
          customCss: book.customCss,
          customHtml: book.customHtml,
        }))}
    />
    <NewBooksBlock
      books={books
        .sort(newestFirst)
        .slice(0, 4)
        .map((book) => ({
          title: book.title,
          createdAt: book.createdAt,
          isCompilation: book.isCompilation,
          authorName: book.friendName,
          editionType: book.primaryEdition.type,
          paperbackVolumes: book.primaryEdition.paperbackVolumes,
          isbn: book.primaryEdition.isbn,
          description: book.shortDescription,
          htmlShortTitle: book.htmlShortTitle,
          documentUrl: getDocumentUrl(book.friendSlug, book.slug),
          authorUrl: getFriendUrl(book.friendSlug, book.friendGender),
        }))}
    />
    {LANG === `en` && (
      <ExploreRegionsBlock
        books={books.map((book) => ({
          title: book.title,
          isCompilation: book.isCompilation,
          authorName: book.friendName,
          editionType: book.primaryEdition.type,
          isbn: book.primaryEdition.isbn,
          url: getDocumentUrl(book.friendSlug, book.slug),
          authorUrl: getFriendUrl(book.friendSlug, book.friendGender),
          region: documentRegion(book),
        }))}
      />
    )}
    {LANG === `en` && (
      <TimelineBlock
        books={books.map((book) => ({
          title: book.title,
          authorName: book.friendName,
          editionType: book.primaryEdition.type,
          isbn: book.primaryEdition.isbn,
          url: getDocumentUrl(book.friendSlug, book.slug),
          authorUrl: getFriendUrl(book.friendSlug, book.friendGender),
          isCompilation: book.isCompilation,
          date:
            book.publishedYear ??
            publishedYear(
              book.friendPrimaryResidence?.durations,
              book.friendBorn,
              book.friendDied,
            ) ??
            1650,
        }))}
      />
    )}
    <AltSiteBlock
      numBooks={numTotalBooks[LANG === `en` ? `es` : `en`]}
      url={
        LANG === `en` ? `https://bibliotecadelosamigos.org` : `https://friendslibrary.com`
      }
    />
    <SearchBlock
      books={books
        .flatMap((book) => book.editions.map((edition) => ({ book, edition })))
        .map(({ book, edition }) => ({
          isbn: edition.isbn,
          editionType: edition.type,
          tags: book.tags,
          authorName: book.friendName,
          authorSlug: book.friendSlug,
          documentTitle: book.title,
          documentSlug: book.slug,
          region: documentRegion(book),
          period: getPeriod(book.publishedYear),
        }))}
    />
  </div>
);

export default ExploreBooks;

export const WhiteOverlay: React.FC<{ children: React.ReactNode }> = ({ children }) => (
  <div className="bg-white text-center py-12 md:py-16 lg:py-20 px-10 sm:px-16 my-6 max-w-screen-md mx-auto">
    {children}
  </div>
);

function getPeriod(date?: number): Period {
  if (!date) return `early`;
  if (date < 1725) return `early`;
  if (date < 1815) return `mid`;
  return `late`;
}
