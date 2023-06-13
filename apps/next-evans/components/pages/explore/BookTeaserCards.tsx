import React from 'react';
import cx from 'classnames';
import type { DocumentWithFriendMeta } from '@/lib/types';
import BookTeaserCard from '../../core/BookTeaserCard';
import { getDocumentUrl, getFriendUrl } from '@/lib/friend';

interface Props {
  className?: string;
  id?: string;
  title: string;
  titleEl: 'h1' | 'h2' | 'h3' | 'h4';
  bgColor: string;
  titleTextColor: string;
  books: DocumentWithFriendMeta[];
}

const BookTeaserCards: React.FC<Props> = ({
  id,
  className,
  title,
  bgColor,
  titleTextColor,
  books,
  titleEl: TitleEl,
}) => {
  if (books.length === 0) return null;
  return (
    <section
      id={id}
      className={cx(
        className,
        `bg-${bgColor}`,
        `BookTeaserCards pb-16`,
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
            key={getDocumentUrl(book.authorSlug, book.slug)}
            title={book.title}
            slug={book.slug}
            id={book.id}
            editionTypes={book.editionTypes}
            shortDescription={book.shortDescription}
            hasAudio={book.hasAudio}
            tags={book.tags}
            numDownloads={book.numDownloads}
            numPages={book.numPages}
            size={book.size}
            customCSS={book.customCSS}
            customHTML={book.customHTML}
            authorSlug={book.authorSlug}
            authorName={book.authorName}
            authorGender={book.authorGender}
            htmlShortTitle={book.title}
            documentUrl={getDocumentUrl(book.authorSlug, book.slug)}
            authorUrl={getFriendUrl(book.authorSlug, book.authorGender)}
            description={book.shortDescription}
            dateAdded={book.dateAdded}
          />
        ))}
      </div>
    </section>
  );
};

export default BookTeaserCards;
