import React from 'react';
import invariant from 'tiny-invariant';
import { price } from '@friends-library/lulu';
import { t } from '@friends-library/locale';
import type { GetStaticPaths, GetStaticProps } from 'next';
import type { Doc } from '../../../lib/types';
import { getAllDocuments, getDocument } from '@/lib/db/documents';
import DocBlock from '@/components/pages/document/DocBlock';
import ListenBlock from '@/components/pages/document/ListenBlock';
import BookTeaserCards from '@/components/pages/explore/BookTeaserCards';
import { isCompilations } from '@/lib/friend';
import ExploreBooksBlock from '@/components/pages/home/ExploreBooksBlock';
import { formatFilesize } from '@/lib/filesize';

export const getStaticPaths: GetStaticPaths = async () => {
  const documents = Object.keys(await getAllDocuments()).map((path) => ({
    friendSlug: path.split(`/`)[0],
    bookSlug: path.split(`/`)[1],
  }));

  return {
    paths: documents.map(({ friendSlug, bookSlug }) => ({
      params: { friend_slug: friendSlug, book_slug: bookSlug },
    })),
    fallback: false,
  };
};

export const getStaticProps: GetStaticProps<Props> = async (context) => {
  const friendSlug = context.params?.friend_slug;
  const bookSlug = context.params?.book_slug;
  invariant(typeof friendSlug === `string`);
  invariant(typeof bookSlug === `string`);

  const primaryDocument = await getDocument(friendSlug, bookSlug);
  invariant(primaryDocument);
  const newestEdition = primaryDocument.mostModernEdition;

  const allBooks = Object.values(await getAllDocuments());
  const otherBooksByAuthor = allBooks
    .filter((book) => book.authorSlug === friendSlug)
    .filter((book) => book.slug !== bookSlug);
  const numTotalBooks = allBooks.length;

  return {
    props: {
      primaryDocument: {
        ...primaryDocument,
        price: price(
          newestEdition.size === `xlCondensed` ? `xl` : newestEdition.size,
          newestEdition.numPages,
        ),
      },
      otherBooksByAuthor,
      numTotalBooks,
    },
  };
};

interface Props {
  primaryDocument: Doc<
    | 'editions'
    | 'authorName'
    | 'shortDescription'
    | 'mostModernEdition'
    | 'authorGender'
    | 'authorSlug'
    | 'hasAudio'
    | 'isComplete'
    | 'originalTitle'
    | 'numDownloads'
    | 'altLanguageId'
    | 'blurb'
  > & { price: number };
  otherBooksByAuthor: Array<
    Doc<'shortDescription' | 'editions' | 'authorGender' | 'createdAt'>
  >;
  numTotalBooks: number;
}

const DocumentPage: React.FC<Props> = ({
  primaryDocument,
  otherBooksByAuthor,
  numTotalBooks,
}) => {
  const audiobook = primaryDocument.mostModernEdition.audiobook;
  return (
    <div>
      <DocBlock {...primaryDocument} />
      {audiobook && (
        <ListenBlock
          complete={!audiobook.isIncomplete}
          m4bFilesizeLq={formatFilesize(audiobook.lq_m4bFilesize)}
          m4bFilesizeHq={formatFilesize(audiobook.hq_m4bFilesize)}
          mp3ZipFilesizeLq={formatFilesize(audiobook.lq_mp3ZipFilesize)}
          mp3ZipFilesizeHq={formatFilesize(audiobook.hq_mp3ZipFilesize)}
          m4bUrlLq={`https://api.friendslibrary.com/download/${primaryDocument.mostModernEdition.id}/audio/m4b/lq`}
          m4bUrlHq={`https://api.friendslibrary.com/download/${primaryDocument.mostModernEdition.id}/audio/m4b/hq`}
          mp3ZipUrlLq={`https://api.friendslibrary.com/download/${primaryDocument.mostModernEdition.id}/audio/mp3s/lq`}
          mp3ZipUrlHq={`https://api.friendslibrary.com/download/${primaryDocument.mostModernEdition.id}/audio/mp3s/hq`}
          podcastUrlLq={`https://api.friendslibrary.com/download/${primaryDocument.mostModernEdition.id}/audio/podcast/lq/podcast.rss`}
          podcastUrlHq={`https://api.friendslibrary.com/download/${primaryDocument.mostModernEdition.id}/audio/podcast/hq/podcast.rss`}
          title={primaryDocument.title}
          trackIdLq={audiobook.parts[0]?.lq_externalTrackId ?? 0}
          trackIdHq={audiobook.parts[0]?.hq_externalTrackId ?? 0}
          playlistIdHq={audiobook.hq_externalPlaylistId}
          playlistIdLq={audiobook.lq_externalPlaylistId}
          numAudioParts={audiobook.parts.length}
        />
      )}
      <BookTeaserCards
        title={
          isCompilations(primaryDocument.authorName)
            ? t`Other Compilations`
            : t`Other Books by this Author`
        }
        titleEl={`h2`}
        bgColor={`flgray-100`}
        titleTextColor={`flblack`}
        books={otherBooksByAuthor}
        noBadges
      />
      {(!primaryDocument.hasAudio || otherBooksByAuthor.length === 0) && (
        <ExploreBooksBlock numTotalBooks={numTotalBooks} />
      )}
    </div>
  );
};

export default DocumentPage;
