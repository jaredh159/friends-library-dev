import React from 'react';
import FeaturedQuoteBlock from '@evans/pages/friend/FeaturedQuoteBlock';
import FriendBlock from '@evans/pages/friend/FriendBlock';
import BookByFriend from '@evans/pages/friend/BookByFriend';
import FriendMeta from '@evans/pages/friend/FriendMeta';
import Testimonial from '@evans/pages/friend/Testimonial';
import TestimonialsBlock from '@evans/pages/friend/TestimonialsBlock';
import MapBlock from '@evans/pages/friend/MapBlock';
import AudioIcon from '@evans/icons/Audio';
import TagsIcon from '@evans/icons/Tags';
import ClockIcon from '@evans/icons/Clock';
import DownloadIcon from '@evans/icons/Download';
import Books7 from '@evans/images/Books7.jpg';
import type { Meta } from '@storybook/react';
import { WebCoverStyles, name, bgImg, fullscreen, setBg } from '../decorators';
import { props as coverProps } from '../cover-helpers';

export default {
  title: 'Site/Pages/Friend', // eslint-disable-line
  decorators: [WebCoverStyles],
  parameters: { layout: `centered` },
} as Meta;

export const AudioIconSvg = () => <AudioIcon />;
export const TagsIconSvg = () => <TagsIcon />;
export const ClockIconSvg = () => <ClockIcon />;
export const DownloadIconSvg = () => <DownloadIcon />;

export const Testimonial_ = () => (
  <Testimonial className="w-64" color="green" quote={LOREM} cite="George Fox" />
);

export const FriendMeta_ = () => (
  <FriendMeta className="w-64" color="green" title="Author Facts">
    <li>Lived: 1808</li>
    <li>Died: 1891</li>
    <li>
      City: <a href="/">London</a>
    </li>
    <li>Foobar: This is pretty long lol rofl</li>
    <li>Country: Great Britain</li>
    <li>Role: Elder</li>
  </FriendMeta>
);

export const FriendBlock_ = fullscreen(() => (
  <FriendBlock gender="female" name="Ann Branson" blurb={blurb} />
));

export const FeaturedQuoteBlock_ = fullscreen(() => (
  <FeaturedQuoteBlock cite="Ann Branson" quote={quote} />
));

export const BookByFriend_ = setBg(`#f1f1f1`, () => (
  <BookByFriend
    isAlone={true}
    {...coverProps}
    bookUrl="/"
    tags={[`journal`, `letters`]}
    hasAudio
    numDownloads={243}
    description="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    pages={[187]}
  />
));

export const TestimonialsOne = fullscreen(
  name(`TestimonialsBlock (one)`, () => (
    <TestimonialsBlock
      testimonials={[
        {
          quote: LOREM,
          cite: `George Fox`,
        },
      ]}
    />
  )),
);

export const TestimonialsTwo = fullscreen(
  name(`TestimonialsBlock (two)`, () => (
    <TestimonialsBlock
      testimonials={[
        {
          quote: LOREM,
          cite: `George Fox`,
        },
        {
          quote: LOREM,
          cite: `Rebecca Jones`,
        },
      ]}
    />
  )),
);

export const TestimonialsThree = fullscreen(
  name(`TestimonialsBlock (three)`, () => (
    <TestimonialsBlock
      testimonials={[
        {
          quote: LOREM,
          cite: `George Fox`,
        },
        {
          quote: LOREM + ` Let's make it a little longer.`,
          cite: `Rebecca Jones`,
        },
        {
          quote: LOREM,
          cite: `Robert Barclay`,
        },
      ]}
    />
  )),
);

export const TestimonialsFour = fullscreen(
  name(`TestimonialsBlock (four)`, () => (
    <TestimonialsBlock
      testimonials={[
        {
          quote: LOREM,
          cite: `George Fox`,
        },
        {
          quote: LOREM + ` Let's make it a little longer.`,
          cite: `Rebecca Jones`,
        },
        {
          quote: LOREM,
          cite: `Robert Barclay`,
        },
        {
          quote: LOREM,
          cite: `Catherine Payton`,
        },
      ]}
    />
  )),
);

export const MapBlock_ = fullscreen(() => (
  <MapBlock
    bgImg={bgImg(Books7)}
    friendName="Ann Branson"
    residences={[
      `London England (1808 -1825)`,
      `Scotland (1825 - 1829)`,
      `Ireland (1829 - 1891)`,
    ]}
    map="UK"
    markers={[
      {
        label: `London, England`,
        top: 69,
        left: 60,
      },
    ]}
  />
));

/* ------------------------------------------- */
/* -------------- UTILITIES ------------------ */
/* ------------------------------------------- */

const quote = `
Humbling herself before God and men, she was exalted by the Lord as a powerful and
prophetic minister, one of the few in her day who stood in the purity and power of the
original Quakers, even while all around her the 200 year old lampstand of the Society
of Friends slowly and tragically burned out.
`;

const blurb = `
Ann Branson (1808-1891) was one of the very last, true ministers (having been prepared,
called, and used of the Lord) in a greatly reduced and sadly degenerate Society. Her
deepest cry to the Lord, from the days of her childhood, was that “His eye would not
pity, nor His hand spare” till He had thoroughly cleansed her heart, and made her a
useful vessel in His house. Humbling herself before God and men, she was exalted by the
Lord as a powerful and prophetic minister, one of the few in her day who stood in the
purity and power of the original Quakers, even while all around her the 200 year old
lampstand of the Society of Friends slowly and tragically burned out.
`;

const LOREM = `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.`;
