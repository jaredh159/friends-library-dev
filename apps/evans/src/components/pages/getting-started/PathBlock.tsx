import React, { useState } from 'react';
import cx from 'classnames';
import { Front } from '@friends-library/cover-component';
import { t } from '@friends-library/locale';
import type { CoverProps } from '@friends-library/types';
import WaveBottomBlock from '../../blocks/WaveBottomBlock';
import Button from '../../Button';
import DownloadIcon from '../../icons/Download';
import AudioIcon from '../../icons/Audio';
import './PathBlock.css';
import Link from '../../Link';

interface Props {
  slug: 'history' | 'doctrinal' | 'spiritual-life' | 'journal';
  color: 'blue' | 'gold' | 'maroon' | 'green';
  title: string;
  children: React.ReactNode;
  books: (CoverProps & {
    hasAudio: boolean;
    documentUrl: string;
    authorUrl: string;
    htmlShortTitle: string;
  })[];
}

const PAGE_SIZE = 4;

const PathBlock: React.FC<Props> = ({ slug, books, title, color, children }) => {
  const [page, setPage] = useState<number>(1);
  if (books.length === 0) return null;
  return (
    <WaveBottomBlock
      color={color}
      className={cx(
        `PathBlock PathBlock--${slug} p-12 text-fl${color}`,
        books.length <= page * PAGE_SIZE && `pb-10`,
      )}
    >
      <h2 className="heading-text mb-6">{title}</h2>
      <p className="body-text mb-12 max-w-4xl mx-auto">{children}</p>
      <div className="PathBooks md:flex flex-wrap text-gray-500 antialiased font-sans tracking-wider text-center relative">
        {books.slice(0, page * PAGE_SIZE).map((book) => (
          <div
            key={book.documentUrl}
            className="pt-4 mb-6 md:mb-20 md:w-1/2 xl:w-1/4 relative flex flex-col justify-start"
          >
            <h3 className="heading-text text-base mb-2 font-normal max-w-xs mx-auto px-2">
              <Link
                className="hover:underline"
                to={book.documentUrl}
                dangerouslySetInnerHTML={{ __html: book.htmlShortTitle }}
              />
            </h3>
            <p className="text-center">
              <Link
                className="inline-block text-center strong-link text-sm mb-10"
                to={book.authorUrl}
              >
                {book.author}
              </Link>
            </p>
            <div className="flex flex-col items-center mt-auto">
              <Link to={book.documentUrl}>
                <Front {...book} shadow={true} scaler={1 / 3} scope="1-3" />
              </Link>
              <div className="mt-2">
                {book.hasAudio && <AudioIcon className="mr-2" />}
                <DownloadIcon />
              </div>
            </div>
          </div>
        ))}
      </div>
      {books.length > page * PAGE_SIZE && (
        <Button
          onClick={() => setPage(page + 1)}
          className="mx-auto mt-12 xl:mb-2"
        >{t`View More`}</Button>
      )}
    </WaveBottomBlock>
  );
};

export default PathBlock;
