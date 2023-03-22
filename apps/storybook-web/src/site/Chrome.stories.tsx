import React from 'react';
import Nav from '@evans/Nav';
import Button from '@evans/Button';
import Hamburger from '@evans/Hamburger';
import SlideoverMenu from '@evans/SlideoverMenu';
import Footer from '@evans/Footer';
import MultiPill from '@evans/MultiPill';
import Mountains from '@evans/images/mountains.jpg';
import type { Meta } from '@storybook/react';
import { fullscreen, name, bgImg } from '../decorators';

export default {
  title: 'Site/Misc/Chrome', // eslint-disable-line
  parameters: { layout: `centered` },
} as Meta;

export const Slideover_Menu = fullscreen(() => <SlideoverMenu onClose={() => {}} />);

export const Hambuger_ = () => <Hamburger onClick={() => {}} />;

export const Footer_ = fullscreen(() => <Footer bgImg={bgImg(Mountains)} />);

export const Button_ = () => (
  <>
    <Button className="mb-6" shadow bg="gold">
      Shadow
    </Button>
    <Button className="mb-6">Click Me</Button>
    <Button className="mb-6 border-4 border-green-300">With Border</Button>
    <Button bg={null} className="bg-red-500 mb-6">
      Custom BG
    </Button>
    <Button className="mb-6" bg="blue">
      Find out more
    </Button>
    <Button disabled className="mb-6">
      disabled
    </Button>
    <Button to="/" bg="green">
      Secondary
    </Button>
  </>
);

export const NavDefault = fullscreen(() => (
  <Nav showCartBadge={false} onCartBadgeClick={() => {}} onHamburgerClick={() => {}} />
));

export const NavCartBadge = fullscreen(() => (
  <Nav showCartBadge onCartBadgeClick={() => {}} onHamburgerClick={() => {}} />
));

export const NavSearching = fullscreen(() => (
  <Nav
    initialSearching
    showCartBadge={false}
    onCartBadgeClick={() => {}}
    onHamburgerClick={() => {}}
  />
));

export const MultiPill_3 = name(`MultiPill (3-part)`, () => (
  <MultiPill
    buttons={[
      { text: `Download`, icon: `cloud-download` },
      { text: `Paperback $4.99`, icon: `book` },
      { text: `Audio Book`, icon: `headphones` },
    ]}
  />
));

export const MultiPill_2 = name(`MultiPill (2-part)`, () => (
  <MultiPill buttons={[{ text: `Download Lo-Fi` }, { text: `Download Hi-Fi` }]} />
));
