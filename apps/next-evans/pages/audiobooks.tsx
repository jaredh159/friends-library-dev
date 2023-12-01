import React from 'react';
import Link from 'next/link';
import { t } from '@friends-library/locale';
import type { GetStaticProps } from 'next';
import type { EditionType } from '@/lib/types';
import api from '@/lib/ssg/api-client';
import AudiobooksHero from '@/components/pages/explore/AudiobooksHero';
import Dual from '@/components/core/Dual';
import BookTeaserCard from '@/components/core/BookTeaserCard';
import { getDocumentUrl, getFriendUrl } from '@/lib/friend';
import Audiobook from '@/components/pages/audiobooks/Audiobook';
import { LANG } from '@/lib/env';
import { newestFirst, shortDate } from '@/lib/dates';
import * as custom from '@/lib/ssg/custom-code';
import Seo, { pageMetaDesc } from '@/components/core/Seo';

interface Props {
  audiobooks: Array<{
    slug: string;
    title: string;
    htmlShortTitle: string;
    editionType: EditionType;
    isbn: string;
    customCss?: string;
    customHtml?: string;
    isCompilation: boolean;
    friendName: string;
    friendSlug: string;
    friendGender: 'male' | 'female' | 'mixed';
    duration: string;
    badgeText?: string;
    shortDescription: string;
  }>;
}

export const getStaticProps: GetStaticProps<Props> = async () => {
  const output = await api.audiobooksPage(LANG);
  output.sort(newestFirst);
  const customCode = await custom.some(output.map(custom.documentSlugs));
  const audiobooks = output
    .map((audio, index) => ({
      slug: audio.slug,
      title: audio.title,
      htmlShortTitle: audio.htmlShortTitle,
      editionType: audio.editionType,
      isbn: audio.isbn,
      isCompilation: audio.isCompilation,
      friendName: audio.friendName,
      friendSlug: audio.friendSlug,
      friendGender: audio.friendGender,
      duration: audio.duration,
      shortDescription: audio.shortDescription,
      ...(index < 2 ? { badgeText: shortDate(audio.createdAt) } : {}),
    }))
    .map((audio) => {
      const coverCode = customCode[`${audio.friendSlug}/${audio.slug}`];
      return coverCode ? custom.merge(audio, coverCode) : audio;
    });
  return { props: { audiobooks } };
};

const AudioBooks: React.FC<Props> = ({ audiobooks }) => (
  <div>
    <Seo
      title={t`Audio Books`}
      description={pageMetaDesc(`audiobooks`, { numAudiobooks: audiobooks.length })}
    />
    <AudiobooksHero numBooks={audiobooks.length} />
    <div className="bg-flgray-200 py-12 xl:pb-6">
      <Dual.H2 className="sans-wider text-center text-2xl md:text-3xl mb-12 px-10">
        <>Recently Added Audio Books</>
        <>Audiolibros añadidos recientemente</>
      </Dual.H2>
      <div className="flex flex-col xl:flex-row items-center justify-center gap-12 xl:gap-28 px-12 xl:px-28 xl:pl-36">
        {audiobooks.slice(0, 2).map((audiobook) => (
          <BookTeaserCard
            {...audiobook}
            className="xl:-ml-8"
            documentUrl={getDocumentUrl(audiobook.friendSlug, audiobook.slug)}
            friendUrl={getFriendUrl(audiobook.friendSlug, audiobook.friendGender)}
            audioDuration={audiobook.duration}
            paperbackVolumes={[222]}
            description={audiobook.shortDescription}
          />
        ))}
      </div>
    </div>
    <div>
      <div className="pt-24">
        <h2 className="sans-wider text-center text-3xl mb-8 px-8">{t`All Audio Books`}</h2>
        <Dual.P className="body-text text-center text-lg mb-12 px-8 sm:px-10">
          <>
            Browse all {audiobooks.length} audiobooks below, or{` `}
            <Link href={t`/audio-help`} className="subtle-link">
              get help with listening here
            </Link>
            .
          </>
          <>
            Explora los {audiobooks.length} audiolibros a continuación u{` `}
            <Link href={t`/audio-help`} className="subtle-link">
              obtén ayuda aquí para escuchar
            </Link>
            .
          </>
        </Dual.P>
      </div>
      <div className="flex gap-x-8 gap-y-36 flex-wrap justify-center py-24 px-4 sm:px-8">
        {audiobooks.map((audiobook, index) => {
          const bgColor = (() => {
            switch (index % 3) {
              case 0:
                return `blue`;
              case 1:
                return `green`;
              case 2:
              default:
                return `gold`;
            }
          })();
          return (
            <Audiobook
              {...audiobook}
              key={getDocumentUrl(audiobook.friendSlug, audiobook.slug)}
              documentUrl={getDocumentUrl(audiobook.friendSlug, audiobook.slug)}
              friendUrl={getFriendUrl(audiobook.friendSlug, audiobook.friendGender)}
              description={audiobook.shortDescription}
              bgColor={bgColor}
            />
          );
        })}
      </div>
    </div>
  </div>
);

export default AudioBooks;
