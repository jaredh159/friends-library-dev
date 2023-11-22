import React from 'react';
import cx from 'classnames';
import type { CoverData } from '@/lib/cover';
import BookTeaserCard from './BookTeaserCard';
import { shortDate } from '@/lib/dates';

export interface Props {
  className?: string;
  id?: string;
  title: string;
  titleEl: 'h2' | 'h3' | 'h4';
  bgColor: string;
  titleTextColor: string;
  books: Array<
    Omit<CoverData, 'printSize'> & {
      audioDuration?: string;
      htmlShortTitle: string;
      documentUrl: string;
      friendUrl: string;
      createdAt: ISODateString;
    }
  >;
  withDateBadges?: boolean;
}

const BookTeaserCards: React.FC<Props> = ({
  id,
  className,
  title,
  bgColor,
  titleTextColor,
  books,
  titleEl: TitleEl,
  withDateBadges = false,
}) => {
  if (books.length === 0) return null;
  return (
    <section
      id={id}
      className={cx(
        className,
        `bg-${bgColor}`,
        `pb-16`,
        `md:pt-16 md:pb-1`,
        `xl:flex xl:flex-wrap xl:justify-center`,
      )}
    >
      <TitleEl
        className={cx(
          `text-${titleTextColor}`,
          `sans-wider px-6 text-2xl text-center mt-10 md:-mt-2 md:mb-12 xl:w-full`,
        )}
      >
        {title}
      </TitleEl>
      <div className="flex justify-center flex-wrap">
        {books.map((book) => (
          <BookTeaserCard
            key={book.documentUrl}
            className="pt-16 md:pt-0 md:mb-16 xl:mx-6"
            {...book}
            badgeText={withDateBadges ? shortDate(book.createdAt) : undefined}
          />
        ))}
      </div>
    </section>
  );
};

export default BookTeaserCards;
