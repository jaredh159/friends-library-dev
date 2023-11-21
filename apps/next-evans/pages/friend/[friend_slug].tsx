import React from 'react';
import Client, { type T } from '@friends-library/pairql/next-evans-build';
import invariant from 'tiny-invariant';
import cx from 'classnames';
import { t, translateOptional as trans } from '@friends-library/locale';
import type { GetStaticPaths, GetStaticProps } from 'next';
import { LANG } from '@/lib/env';
import FriendBlock from '@/components/pages/friend/FriendBlock';
import FeaturedQuoteBlock from '@/components/pages/friend/FeaturedQuoteBlock';
import BookByFriend from '@/components/pages/friend/BookByFriend';
import TestimonialsBlock from '@/components/pages/friend/TestimonialsBlock';
import MapBlock from '@/components/pages/friend/MapBlock';
import getResidences from '@/lib/residences';
import { getDocumentUrl } from '@/lib/friend';
import { sortDocuments } from '@/lib/document';
import * as custom from '@/lib/ssg/custom-code';
import Seo from '@/components/core/Seo';
import { friendPageMetaDesc } from '@/lib/seo';

type Props = T.FriendPage.Output;

export const getStaticPaths: GetStaticPaths = async () => {
  const slugs = await Client.node(process).publishedFriendSlugs(LANG);
  return {
    paths: slugs.map((friend_slug) => ({ params: { friend_slug } })),
    fallback: false,
  };
};

export const getStaticProps: GetStaticProps<Props> = async (context) => {
  invariant(typeof context.params?.friend_slug === `string`);
  const friend = await Client.node(process).friendPage({
    lang: LANG,
    slug: context.params.friend_slug,
  });
  const customCode = await custom.some(
    friend.documents.map(({ slug }) => ({
      friendSlug: friend.slug,
      documentSlug: slug,
    })),
  );
  friend.documents = friend.documents.map((doc) => {
    const docCode = customCode[`${friend.slug}/${doc.slug}`];
    return docCode ? custom.merge(doc, docCode) : doc;
  });
  friend.documents.sort(sortDocuments);
  return { props: friend };
};

const Friend: React.FC<Props> = ({
  name,
  isCompilations,
  gender,
  slug,
  description,
  quotes,
  documents,
  residences,
  born,
  died,
}) => {
  const onlyOneBook = documents.length === 1;
  const mapData = getResidences(residences);
  let mapBlock;
  if (!isCompilations) {
    invariant(mapData[0] !== undefined);
    mapBlock = (
      <MapBlock
        friendName={name}
        residences={residences.flatMap((r) => {
          const place = `${trans(r.city)}, ${trans(r.region)}`;
          if (r.durations) {
            return r.durations.map((d) => `${place} (${d.start} - ${d.end})`);
          }
          let residence = place;
          if (born && died) {
            residence += ` (${born} - ${died})`;
          } else if (died) {
            residence += ` (died: ${died})`;
          }
          return residence;
        })}
        map={mapData[0].map}
        markers={mapData.map((res) => ({
          label: `${trans(res.city)}, ${trans(res.region)}`,
          top: res.top,
          left: res.left,
        }))}
      />
    );
  }

  return (
    <div>
      <Seo
        title={name}
        description={friendPageMetaDesc(
          name,
          description,
          documents.map((doc) => doc.title),
          documents.filter((doc) => doc.hasAudio).length,
          isCompilations,
        )}
      />
      <FriendBlock name={name} gender={gender} blurb={description} />
      {quotes[0] && <FeaturedQuoteBlock cite={quotes[0].source} quote={quotes[0].text} />}
      <div className="bg-flgray-100 px-8 pt-12 pb-4 lg:px-8">
        <h2 className="text-xl font-sans text-center tracking-wider font-bold mb-8">
          {name === `Compilations`
            ? t`All Compilations (${documents.length})`
            : t`Books by ${name}`}
        </h2>
        <div
          className={cx(`flex flex-col items-center `, `xl:justify-center`, {
            'lg:flex-row lg:justify-between lg:flex-wrap lg:items-stretch': !onlyOneBook,
          })}
        >
          {documents.map((doc) => (
            <BookByFriend
              key={doc.id}
              htmlShortTitle={doc.htmlShortTitle}
              isAlone={onlyOneBook}
              className="mb-8 lg:mb-12"
              tags={doc.tags}
              hasAudio={doc.hasAudio}
              bookUrl={getDocumentUrl(slug, doc.slug)}
              numDownloads={doc.numDownloads}
              pages={doc.primaryEdition.numPages}
              description={doc.shortDescription}
              lang={LANG}
              title={doc.title}
              isCompilation={isCompilations}
              author={name}
              size={doc.primaryEdition.size}
              edition={doc.primaryEdition.type}
              isbn={doc.primaryEdition.isbn}
              customCss={doc.customCss || ``}
              customHtml={doc.customHtml || ``}
            />
          ))}
        </div>
      </div>
      {mapBlock}
      <TestimonialsBlock testimonials={quotes.slice(1, quotes.length)} />
    </div>
  );
};

export default Friend;
