import React from 'react';
import cx from 'classnames';
import type { Doc } from '@/lib/types';
import BookTeaserCard from '../../core/BookTeaserCard';
import { getDocumentUrl, getFriendUrl } from '@/lib/friend';

interface Props {
  className?: string;
  id?: string;
  title: string;
  titleEl: 'h1' | 'h2' | 'h3' | 'h4';
  bgColor: string;
  titleTextColor: string;
  books: Array<Doc<'editions' | 'createdAt' | 'authorGender' | 'shortDescription'>>;
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
            className="pt-16 md:pt-0 md:mb-16 xl:mx-6"
            key={getDocumentUrl(book)}
            title={book.title}
            editions={book.editions}
            customCSS={book.customCSS}
            customHTML={book.customHTML}
            authorName={book.authorName}
            htmlShortTitle={book.title}
            documentUrl={getDocumentUrl(book)}
            authorUrl={getFriendUrl(book.authorSlug, book.authorGender)}
            description={book.shortDescription}
            badgeText={
              withDateBadges
                ? new Date(book.createdAt).toLocaleDateString(`en-US`, {
                    month: `short`,
                    day: `numeric`,
                  })
                : undefined
            }
            isbn={book.isbn}
          />
        ))}
      </div>
    </section>
  );
};

export default BookTeaserCards;
