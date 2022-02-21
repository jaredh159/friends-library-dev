import { ChevronRightIcon } from '@heroicons/react/solid';
import React from 'react';
import { Link as RouterLink } from 'react-router-dom';

const Home: React.FC = () => {
  return (
    <div>
      <ul className="space-y-2 text-xl text-flprimary">
        <Link to="/orders/new">Create an Order</Link>
        <Link to="/friends">View Friend</Link>
        <Link to="/friends/new">Create New Friend</Link>
        <Link to="/documents">View Documents</Link>
        <Link to="/tokens">View Tokens</Link>
        <Link to="/tokens/new">Create New Token</Link>
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
