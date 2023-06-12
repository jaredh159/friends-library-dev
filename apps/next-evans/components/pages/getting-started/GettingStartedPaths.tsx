import React from 'react';
import { t } from '@friends-library/locale';
import type { CoverProps } from '@friends-library/types';
import type { DocumentWithFriendMeta } from '@/lib/types';
import PathBlock from './PathBlock';
import { LANG } from '@/lib/env';
import { getFriendUrl, isCompilations } from '@/lib/friend';
import { mostModernEdition } from '@/lib/editions';

interface Props {
  HistoryBlurb: React.FC;
  JournalsBlurb: React.FC;
  DevotionalBlurb: React.FC;
  DoctrineBlurb: React.FC;
  books: {
    history: Array<DocumentWithFriendMeta>;
    doctrine: Array<DocumentWithFriendMeta>;
    spiritualLife: Array<DocumentWithFriendMeta>;
    journals: Array<DocumentWithFriendMeta>;
  };
}

const GettingStartedPaths: React.FC<Props> = ({
  HistoryBlurb,
  DoctrineBlurb,
  DevotionalBlurb,
  JournalsBlurb,
  books,
}) => (
  <>
    <PathBlock
      slug="history"
      title={LANG === `en` ? `History of the Quakers` : `Historia de los Cuáqueros`}
      books={prepareBooks(books.history)}
      color="maroon"
    >
      <HistoryBlurb />
    </PathBlock>
    <PathBlock
      slug="doctrinal"
      title={LANG === `en` ? `The Quaker Doctrine` : `La Doctrina de los Cuáqueros`}
      books={prepareBooks(books.doctrine)}
      color="blue"
    >
      <DoctrineBlurb />
    </PathBlock>
    <PathBlock
      slug="spiritual-life"
      title={t`Spiritual Life`}
      books={prepareBooks(books.spiritualLife)}
      color="green"
    >
      <DevotionalBlurb />
    </PathBlock>
    <PathBlock
      slug="journal"
      title={LANG === `en` ? `Journals` : `Biográfico`}
      books={prepareBooks(books.journals)}
      color="gold"
    >
      <JournalsBlurb />
    </PathBlock>
  </>
);

export default GettingStartedPaths;

function prepareBooks(books: DocumentWithFriendMeta[]): (CoverProps & {
  documentUrl: string;
  authorUrl: string;
  htmlShortTitle: string;
  hasAudio: boolean;
})[] {
  return books.map((book) => ({
    lang: LANG,
    title: book.title,
    isCompilation: isCompilations(book.authorName),
    author: book.authorName,
    size: `s`,
    pages: 7,
    edition: mostModernEdition(book.editionTypes),
    isbn: ``,
    blurb: ``,
    customCss: book.customCSS || ``,
    customHtml: book.customHTML || ``,
    documentUrl: `/${book.authorSlug}/${book.slug}`,
    authorUrl: getFriendUrl(book.authorSlug, book.authorGender),
    htmlShortTitle: book.title,
    hasAudio: book.hasAudio,
  }));
}
