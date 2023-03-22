import React from 'react';
import Audio from '@evans/icons/Audio';
import Calendar from '@evans/icons/Calendar';
import Clock from '@evans/icons/Clock';
import Download from '@evans/icons/Download';
import Ebook from '@evans/icons/Ebook';
import Epub from '@evans/icons/Epub';
import Flag from '@evans/icons/Flag';
import Mobi from '@evans/icons/Mobi';
import Pdf from '@evans/icons/Pdf';
import PlayTriangle from '@evans/icons/PlayTriangle';
import Rotate from '@evans/icons/Rotate';
import Search from '@evans/icons/Search';
import Tags from '@evans/icons/Tags';
import ThinLogo from '@evans/icons/ThinLogo';
import Book from '@evans/icons/Book';
import Headphones from '@evans/icons/Headphones';
import Bookmark from '@evans/icons/Bookmark';
import Globe from '@evans/icons/Globe';
import Star from '@evans/icons/Star';
import type { Meta } from '@storybook/react';

export default {
  title: 'Site/Misc/Icons', // eslint-disable-line
} as Meta;

export const Icons = () => (
  <div className="flex flex-xcol flex-wrap items-start">
    <Bg title="Star">
      <Star tailwindColor="white" />
    </Bg>
    <Bg title="Globe">
      <Globe tailwindColor="white" />
    </Bg>
    <Bg title="Bookmark">
      <Bookmark tailwindColor="white" />
    </Bg>
    <Bg title="Headphones">
      <Headphones tailwindColor="white" />
    </Bg>
    <Bg title="Book">
      <Book tailwindColor="white" />
    </Bg>
    <Bg title="Audio">
      <Audio tailwindColor="white" />
    </Bg>
    <Bg title="Calendar">
      <Calendar />
    </Bg>
    <Bg title="Clock">
      <Clock tailwindColor="white" />
    </Bg>
    <Bg title="Download">
      <Download tailwindColor="white" />
    </Bg>
    <Bg title="Ebook" size={20}>
      <Ebook tailwindColor="white" />
    </Bg>
    <Bg title="Epub" size={20}>
      <Epub tailwindColor="white" />
    </Bg>
    <Bg title="Flag">
      <Flag />
    </Bg>
    <Bg title="Mobi" size={20}>
      <Mobi tailwindColor="white" />
    </Bg>
    <Bg title="Pdf" size={20}>
      <Pdf tailwindColor="white" />
    </Bg>
    <Bg title="PlayTriangle" size={40}>
      <PlayTriangle tailwindColor="white" />
    </Bg>
    <Bg title="Rotate" size={16}>
      <Rotate tailwindColor="white" />
    </Bg>
    <Bg title="Search">
      <Search tailwindColor="white" />
    </Bg>
    <Bg title="Tags">
      <Tags tailwindColor="white" />
    </Bg>
    <Bg title="ThinLogo">
      <ThinLogo />
    </Bg>
  </div>
);

const Bg: React.FC<{ children: React.ReactNode; size?: number; title?: string }> = ({
  children,
  title,
  size = 10,
}) => (
  <div className="m-10 flex flex-col items-center justify-start">
    <h1 className="text-monospace text-red-700 text-center mb-4">&lt;{title} /&gt;</h1>
    <div
      className={`bg-flprimary w-${size} h-${size} flex items-center justify-center rounded-full text-white`}
    >
      {children}
    </div>
  </div>
);
