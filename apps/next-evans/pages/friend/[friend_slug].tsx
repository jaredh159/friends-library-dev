import { PrismaClient } from '@prisma/client';
import invariant from 'tiny-invariant';
import type { GetStaticPaths, GetStaticProps } from 'next';
import FeaturedQuoteBlock from '@/components/pages/friend/FeaturedQuoteBlock';
import FriendBlock from '@/components/pages/friend/FriendBlock';
import TestimonialsBlock from '@/components/pages/friend/TestimonialsBlock';
import { LANG } from '@/lib/env';

const client = new PrismaClient();

export const getStaticPaths: GetStaticPaths = async () => {
  const allFriends = await client.friends.findMany({
    where: { lang: LANG },
    select: { slug: true },
  });

  const paths = allFriends.map((friend) => ({
    params: { friend_slug: friend.slug },
  }));

  return { paths, fallback: false };
};

export const getStaticProps: GetStaticProps<Props> = async (context) => {
  invariant(typeof context.params?.friend_slug === `string`);
  const friend = await client.friends.findFirst({
    where: {
      slug: context.params.friend_slug,
      lang: LANG,
    },
    select: {
      name: true,
      gender: true,
      description: true,
      friend_quotes: {
        select: {
          text: true,
          source: true,
        },
      },
    },
  });
  invariant(friend !== null);
  return {
    props: {
      ...friend,
      quotes: friend.friend_quotes.map((q) => ({ quote: q.text, cite: q.source })),
    },
  };
};

interface Props {
  name: string;
  gender: 'male' | 'female' | 'mixed';
  description: string;
  quotes: Array<{ quote: string; cite: string }>;
}

const Friend: React.FC<Props> = ({ name, gender, description, quotes }) => (
  <div>
    <FriendBlock name={name} gender={gender} blurb={description} />
    {quotes[0] && <FeaturedQuoteBlock cite={quotes[0].cite} quote={quotes[0].quote} />}
    <TestimonialsBlock testimonials={quotes.slice(1, quotes.length)} />
  </div>
);

export default Friend;
