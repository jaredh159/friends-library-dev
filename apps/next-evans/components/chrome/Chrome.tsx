import React from 'react';
import Nav from './Nav';

interface Props {
  children: React.ReactNode;
}

const Chrome: React.FC<Props> = ({ children }) => (
    <div className="">
      <Nav showCartBadge={true} onCartBadgeClick={() => {}} onHamburgerClick={() => {}} />
      <main className="mt-[70px]">{children}</main>
    </div>
  );

export default Chrome;
