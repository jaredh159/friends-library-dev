import React from 'react';
import { GetStaticProps } from 'next';
import { PrismaClient, friends as Friend } from '@prisma/client';
import { LANG } from '@/lib/env';
import FriendsPageHero from '@/components/pages/friends/FriendsPageHero';
import BgImage from '@/public/images/street.jpg';
import { t } from '@/../../libs-ts/locale/src';
import FriendCard from '@/components/pages/friends/FriendCard';
import invariant from 'tiny-invariant';
import ControlsBlock from '@/components/pages/friends/ControlsBlock';

export const getStaticProps: GetStaticProps<Props> = async () => {
  const client = new PrismaClient();
  const friends = await client.friends.findMany({
    where: { lang: LANG },
    select: {
      name: true,
      created_at: true,
      gender: true,
      slug: true,
      born: true,
      died: true,
      friend_residences: {
        select: {
          city: true,
          region: true,
        },
      },
      documents: {
        select: {
          id: true,
        },
      },
    },
  });

  return {
    props: {
      friends: friends
        .filter((friend) => friend.friend_residences[0] !== undefined)
        .map((friend) => {
          invariant(friend.friend_residences[0] !== undefined);
          return {
            ...friend,
            created_at: null,
            numBooks: friend.documents.length,
            region: `${friend.friend_residences[0].city}, ${friend.friend_residences[0].region}`,
            dateAdded: friend.created_at.toLocaleDateString(),
          };
        }),
    },
  };
};

interface Props {
  friends: Array<
    Pick<Friend, 'name' | 'gender' | 'slug' | 'born' | 'died'> & {
      region: string;
      numBooks: number;
      dateAdded: string;
    }
  >;
}

const Friends: React.FC<Props> = ({ friends }) => {
  const mostRecentFriends = friends
    .sort((a, b) => {
      return new Date(b.dateAdded).getTime() - new Date(a.dateAdded).getTime();
    })
    .slice(0, 2);

  return (
    <div>
      <FriendsPageHero numFriends={787} bgImg={BgImage.src} />
      <section className="sm:px-16 py-16">
        <h2 className="text-center pb-8 sans-wider text-2xl px-8">{t`Recently Added Authors`}</h2>
        <div className="flex flex-col xl:flex-row justify-center xl:items-center space-y-16 xl:space-y-0 xl:space-x-12">
          {mostRecentFriends.map((friend, i) => (
            <FriendCard
              gender={friend.gender === 'mixed' ? 'male' : friend.gender}
              name={friend.name}
              region={friend.region}
              numBooks={friend.numBooks}
              featured
              born={friend.born || undefined}
              died={friend.died || undefined}
              url={`/${
                LANG === `en` ? `friend` : friend.gender === `female` ? `amiga` : `amigo`
              }/${friend.slug}`}
              color={i === 0 ? 'blue' : 'green'}
              className="xl:w-1/2 xl:max-w-screen-sm"
              key={friend.slug}
            />
          ))}
        </div>
      </section>
      <ControlsBlock
        sortOption={'foo?'}
        setSortOption={() => {}}
        searchQuery={'bar?'}
        setSearchQuery={() => {}}
      />
      <div className="bg-flgray-200 flex justify-center flex-row flex-wrap">
        {friends.map((friend, i) => (
          <FriendCard
            className="m-8 xl:m-16"
            gender={friend.gender === 'mixed' ? 'male' : friend.gender}
            name={friend.name}
            region={friend.region}
            numBooks={friend.numBooks}
            url={`/${
              LANG === `en` ? `friend` : friend.gender === `female` ? `amiga` : `amigo`
            }/${friend.slug}`}
            born={friend.born || undefined}
            died={friend.died || undefined}
            color={(() => {
              switch (i % 4) {
                case 0:
                  return 'blue';
                case 1:
                  return 'green';
                case 2:
                  return 'maroon';
                default:
                  return 'gold';
              }
            })()}
          />
        ))}
      </div>
    </div>
  );
};

export default Friends;
