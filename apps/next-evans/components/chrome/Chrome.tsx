import React, { useState } from 'react';
import cx from 'classnames';
import Nav from './Nav';
import Slideover from './Slideover';
import Footer from './Footer';

interface Props {
  children: React.ReactNode;
}

const Chrome: React.FC<Props> = ({ children }) => {
  const [slideoverOpen, setSlideoverOpen] = useState(false);

  return (
    <div className="relative">
      <div
        className={cx(
          `fixed w-full h-full z-50 top-0 left-0 transition-[backdrop-filter,background-color] duration-200`,
          slideoverOpen
            ? `bg-black/30 backdrop-blur-sm pointer-events-auto`
            : `pointer-events-none`,
        )}
        onClick={() => setSlideoverOpen(false)}
      >
        <Slideover close={() => setSlideoverOpen(false)} isOpen={slideoverOpen} />
      </div>
      <Nav
        showCartBadge={true}
        onCartBadgeClick={() => {}}
        onHamburgerClick={() => setSlideoverOpen(true)}
      />
      <main className="pt-[70px]">{children}</main>
      <Footer />
    </div>
  );
};

export default Chrome;
