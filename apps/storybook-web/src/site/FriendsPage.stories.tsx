import React, { useState } from 'react';
import FriendPageHero from '@evans/pages/friends/FriendsPageHero';
import CircleSilhouette from '@evans/pages/friends/CircleSilhouette';
import CompilationsBlock from '@evans/pages/friends/CompilationsBlock';
import FriendCard from '@evans/pages/friends/FriendCard';
import ControlsBlock from '@evans/pages/friends/ControlsBlock';
import Village from '@evans/images/village.jpg';
import Street from '@evans/images/street.jpg';
import type { Meta } from '@storybook/react';
import { bgImg, centered, name, setBg } from '../decorators';

export default {
  title: 'Site/Pages/All Friends', // eslint-disable-line
  parameters: { layout: `fullscreen` },
} as Meta;

export const ControlsBlock_ = () => {
  const [searchQuery, setSearchQuery] = useState<string>(``);
  const [sortOption, setSortOption] = useState<string>(`Alphabetical`);
  return (
    <ControlsBlock
      searchQuery={searchQuery}
      setSearchQuery={setSearchQuery}
      sortOption={sortOption}
      setSortOption={setSortOption}
    />
  );
};

export const FriendCardsTwo = name(`FriendCard (two)`, () => (
  <div>
    <FriendCard
      className=""
      featured
      name="Ann Branson"
      born={1799}
      died={1808}
      region="Leicester, England"
      numBooks={2}
      url="/"
      gender="female"
      color="flgreen"
    />
    <FriendCard
      className=""
      featured
      name="George Fox"
      born={1799}
      died={1808}
      region="Leicester, England"
      numBooks={2}
      url="/"
      gender="male"
      color="flblue"
    />
  </div>
));

export const FriendCardsThree = name(`FriendCard (multi)`, () => (
  <div className="bg-flgray-200 p-8">
    <FriendCard
      className="mb-8"
      featured
      name="Ann Branson"
      born={1799}
      died={1808}
      region="Barnseville, Ohio"
      numBooks={2}
      url="/"
      gender="female"
      color="flgreen"
    />
    <FriendCard
      className="mb-20 max-w-screen-sm"
      name="Ann Branson"
      born={1799}
      died={1808}
      region="Barnseville, Ohio"
      numBooks={2}
      url="/"
      gender="female"
      color="flgreen"
    />
    <FriendCard
      featured
      name="George Fox"
      born={1799}
      died={1808}
      region="Leicester, England"
      numBooks={2}
      url="/"
      gender="male"
      color="flblue"
    />
  </div>
));

export const CircleSilhouettes = setBg(
  `lightgray`,
  centered(() => (
    <div className="space-x-4 flex p-6">
      <CircleSilhouette bgColor="white" gender="male" fgColor="flgreen" />
      <CircleSilhouette bgColor="flgreen" gender="male" fgColor="white" />
      <CircleSilhouette bgColor="white" gender="female" fgColor="flgreen" />
      <CircleSilhouette bgColor="flgreen" gender="female" fgColor="white" />
    </div>
  )),
);

export const CompilationsBlock_ = () => <CompilationsBlock bgImg={bgImg(Village)} />;

export const FriendsPageHero = () => (
  <FriendPageHero bgImg={bgImg(Street)} numFriends={92} />
);
