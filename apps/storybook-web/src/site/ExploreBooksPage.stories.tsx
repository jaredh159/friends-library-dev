import React, { useState } from 'react';
import { action as a } from '@storybook/addon-actions';
import ActiveFilters from '@evans/pages/explore/ActiveFilters';
import TimePicker from '@evans/pages/explore/TimePicker';
import FilterSelectDropdown from '@evans/pages/explore/FilterSelectDropdown';
import FilterControls from '@evans/pages/explore/FilterControls';
import NavBlock from '@evans/pages/explore/NavBlock';
import GettingStartedLinkBlock from '@evans/pages/explore/GettingStartedLinkBlock';
import AltSiteBlock from '@evans/pages/explore/AltSiteBlock';
import SelectableMap from '@evans/pages/explore/SelectableMap';
import BookSlider from '@evans/pages/explore/BookSlider';
import NewBooksBlock from '@evans/pages/explore/NewBooksBlock';
import UpdatedEditionsBlock from '@evans/pages/explore/UpdatedEditionsBlock';
import AudioBooksBlock from '@evans/pages/explore/AudioBooksBlock';
import RegionBlock from '@evans/pages/explore/RegionBlock';
import SearchBlock from '@evans/pages/explore/SearchBlock';
import TimelineBlock from '@evans/pages/explore/TimelineBlock';
import MapSlider from '@evans/pages/explore/MapSlider';
import BookTeaserCard from '@evans/BookTeaserCard';
import WaterPath from '@evans/images/water-path.jpg';
import Headphones from '@evans/images/headphones.jpg';
import Castle from '@evans/images/castle.jpg';
import Books3 from '@evans/images/Books3.jpg';
import type { Region, Book } from '@evans/pages/explore/types';
import type { Meta } from '@storybook/react';
import { WebCoverStyles, bgImg, name, centered } from '../decorators';
import { props as coverProps } from '../cover-helpers';

export default {
  title: 'Site/Pages/Explore', // eslint-disable-line
  decorators: [WebCoverStyles],
  parameters: { layout: `fullscreen` },
} as Meta;

export const SearchBlockUnused = () => (
  <SearchBlock bgImg={bgImg(WaterPath)} books={[]} initialUsed={false} />
);

export const SearchBlockResults = () => (
  <SearchBlock
    books={pileOfBooks}
    bgImg={bgImg(WaterPath)}
    initialFilters={[`edition.updated`]}
  />
);

export const NewBooksBlockOne = name(`NewsBooksBlock (one)`, () => (
  <NewBooksBlock books={[book()]} />
));

export const NewBooksBlockTwo = name(`NewsBooksBlock (two)`, () => (
  <NewBooksBlock books={[book(), book()]} />
));

export const NewBooksBlockThree = name(`NewsBooksBlock (three)`, () => (
  <NewBooksBlock books={[book(), book(), book()]} />
));

export const NewBooksBlockFour = name(`NewsBooksBlock (four)`, () => (
  <NewBooksBlock books={[book(), book(), book(), book()]} />
));

export const UpdatedEditionsBlock_ = () => <UpdatedEditionsBlock books={pileOfBooks} />;

export const AudioBooksBlock_ = () => (
  <AudioBooksBlock bgImg={bgImg(Headphones)} books={pileOfBooks} />
);

export const TimelineBlock_ = () => (
  <TimelineBlock
    bgImg={bgImg(Castle)}
    books={[
      ...pileOfBooks,
      ...pileOfBooks.map((b) => ({ ...b, documentUrl: `/2/${b.documentUrl}` })),
      ...pileOfBooks.map((b) => ({ ...b, documentUrl: `/3/${b.documentUrl}` })),
    ]}
  />
);

export const RegionBlock_ = () => (
  <RegionBlock
    books={[
      ...pileOfBooks,
      ...pileOfBooks.map((b) => ({ ...b, documentUrl: `/2/${b.documentUrl}` })),
      ...pileOfBooks.map((b) => ({ ...b, documentUrl: `/3/${b.documentUrl}` })),
    ]}
  />
);

export const BookSlider_ = centered(() => <BookSlider books={pileOfBooks} />);

export const TimePicker_ = () => {
  const [date, setDate] = useState<number>(1650);
  return (
    <div className="bg-gray-600 p-16 h-screen">
      <TimePicker selected={date} setSelected={setDate} />
    </div>
  );
};

export const NavBlock_ = () => <NavBlock />;

export const AltSiteBlock_ = () => <AltSiteBlock numBooks={43} url="/" />;

export const GettingStartedBlock = () => (
  <GettingStartedLinkBlock bgImg={bgImg(Books3)} />
);

export const MapSlider_ = () => {
  const [region, setRegion] = useState<Region>(`England`);
  return <MapSlider region={region} setRegion={setRegion} />;
};

export const SelectableMap_ = () => {
  const [region, selectRegion] = useState<string>(`England`);
  return <SelectableMap selectedRegion={region} selectRegion={selectRegion} />;
};

export const FilterControls_ = () => {
  const [selected, setSelected] = useState<string[]>([`edition.updated`]);
  const [query, setQuery] = useState<string>(``);
  return (
    <FilterControls
      activeFilters={selected}
      setActiveFilters={setSelected}
      searchQuery={query}
      setSearchQuery={setQuery}
    />
  );
};

export const ActiveFilters_ = () => (
  <ActiveFilters
    groups={[
      {
        label: `Editions`,
        filters: [
          { clear: a(`clear`), text: `Updated (33)` },
          { clear: a(`clear`), text: `Original (14)` },
          { clear: a(`clear`), text: `Modernized (53)` },
        ],
      },
      {
        label: `Tags`,
        filters: [{ clear: a(`clear`), text: `Journal (54)` }],
      },
      {
        label: `Region`,
        filters: [{ clear: a(`clear`), text: `Scotland (3)` }],
      },
    ]}
    clearAll={a(`clear all`)}
  />
);

export const BookTeaserCard_ = () => (
  <div className="bg-flblue py-16">
    <BookTeaserCard {...book()} />
  </div>
);

export const BookTeaserCardAudio = name(`BookTeaserCard (audio)`, () => (
  <div className="bg-flblue py-16">
    <BookTeaserCard className="mb-16" audioDuration="45:00" {...book()} />
  </div>
));

export const BookTeaserCardBoth = name(`BookTeaserCard (both)`, () => (
  <div className="bg-flblue py-16">
    <BookTeaserCard className="mb-16" audioDuration="45:00" {...book()} />
    <BookTeaserCard {...book()} />
  </div>
));

export const FilterSelectDropdown_ = () => {
  const [selected, setSelected] = useState<string[]>([`edition.updated`]);
  return (
    <div className="bg-flblue-400 h-screen p-12 flex justify-center items-start">
      <FilterSelectDropdown selected={selected} setSelected={setSelected} />
    </div>
  );
};

/* ------------------------------------------- */
/* -------------- UTILITIES ------------------ */
/* ------------------------------------------- */

type KitchenSinkBook = Book & {
  region: Region;
  date: number;
  tags: string[];
  period: 'early' | 'mid' | 'late';
  badgeText: string;
  description: string;
};

function book(props: Partial<KitchenSinkBook> = {}): KitchenSinkBook {
  return {
    ...coverProps,
    description: `This is the modern edition of this book title. This is an explanation of what the difference is between the updated, modern, and the real OG version...`,
    authorUrl: `/`,
    documentUrl: (props.author || coverProps.author).toLowerCase().replace(/ /g, `-`),
    tags: [`journal`, `letters`],
    period: `early`,
    date: 1680,
    region: `England`,
    badgeText: `Feb 10`,
    ...props,
  };
}

const pileOfBooks = [
  book({
    region: `England`,
    author: `Samuel Rundell`,
    title: `The Work of Vital Religion in the Soul`,
    date: 1650,
  }),
  book({
    region: `Ireland`,
    author: `Stephen Crisp`,
    title: `A Plain Pathway`,
    date: 1650,
  }),
  book({
    region: `Scotland`,
    author: `Charles Marshall`,
    title: `The Journal of Charles Marshall`,
    date: 1650,
  }),
  book({
    region: `Eastern US`,
    author: `George Fox`,
    title: `The Journal of George Fox`,
    date: 1700,
  }),
  book({
    region: `Scotland`,
    author: `William Penn`,
    title: `No Cross, No Crown`,
    date: 1700,
  }),
  book({
    region: `England`,
    author: `Hugh Turford`,
    title: `Walk in the Spirit`,
    date: 1700,
  }),
  book({
    region: `Eastern US`,
    author: `Robert Barclay`,
    title: `Saved to the Uttermost`,
    date: 1850,
  }),
  book({
    region: `Ireland`,
    author: `Robert Barclay`,
    title: `Waiting Upon the Lord`,
    date: 1850,
  }),
  book({
    region: `Western US`,
    author: `Joseph Phipps`,
    title: `The Original and Present State of Man`,
    date: 1850,
  }),
];
