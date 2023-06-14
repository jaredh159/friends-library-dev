import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import Link from 'next/link';
import type { DocumentWithMeta } from '@/lib/types';
import AudiobooksHero from './AudiobooksHero';
import Album from '@/components/core/Album';
import Button from '@/components/core/Button';
import { LANG } from '@/lib/env';
import { getDocumentUrl, isCompilations } from '@/lib/friend';
import { mostModernEdition } from '@/lib/editions';

interface Props {
  books: Array<DocumentWithMeta>;
}

const AudioBooksBlock: React.FC<Props> = ({ books }) => (
  <div id="AudioBooksBlock" className="AudioBooksBlock text-center pb-16">
    <AudiobooksHero className="p-10 pb-56 md:pb-64" numBooks={books.length} />
    <div
      className={cx(
        `-mt-16 mx-16 flex flex-col items-center`,
        `md:flex-row md:items-start md:flex-wrap md:justify-center md:content-center`,
        `lg:mx-8`,
      )}
    >
      {books.slice(0, 4).map((book) => (
        <Link
          href={`${getDocumentUrl(book.authorSlug, book.slug)}#audiobook`}
          className={cx(
            `flex flex-col items-center mb-10 group`,
            `md:w-64 md:mx-12`,
            `lg:mx-4 lg:w-56`,
          )}
          key={getDocumentUrl(book.authorSlug, book.slug)}
        >
          <Album
            author={book.authorName}
            edition={mostModernEdition(book.editionTypes)}
            customCss={book.customCSS ?? ``}
            customHtml={book.customHTML ?? ``}
            lang={LANG}
            isCompilation={isCompilations(book.authorSlug)}
            isbn={``}
            className="mb-8"
            {...book}
          />
          <h4
            className="font-sans text-flgray-900 text-base tracking-wider group-hover:underline"
            dangerouslySetInnerHTML={{ __html: book.title }}
          />
        </Link>
      ))}
    </div>
    {books.length - 4 > 0 && (
      <Button className="mx-auto mt-12 md:mt-6" to={t`/audiobooks`}>
        {t`View ${books.length - 4} More`} &rarr;
      </Button>
    )}
  </div>
);

export default AudioBooksBlock;
