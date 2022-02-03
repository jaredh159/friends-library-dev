import { ChevronRightIcon } from '@heroicons/react/solid';
import React from 'react';
import { Link as RouterLink } from 'react-router-dom';

const Home: React.FC = () => {
  return (
    <div>
      <ul className="space-y-2 text-xl text-flprimary">
        <Link to="/orders">Create an Order</Link>
        <Link to="/friends">View Friends</Link>
      </ul>
    </div>
  );
};

export default Home;

const Link: React.FC<{ to: string }> = ({ to, children }) => (
  <li>
    <RouterLink to={to} className="border-b border-dotted border-flprimary/50">
      {children}
    </RouterLink>
    <ChevronRightIcon className="ml-2 inline w-[22px] h-[22px]" />
  </li>
);
