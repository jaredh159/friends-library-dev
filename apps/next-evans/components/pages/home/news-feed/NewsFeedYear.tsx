import React from 'react';
import NewsFeedItem from './NewsFeedItem';

interface Props {
  year: string;
  items: Omit<React.ComponentProps<typeof NewsFeedItem>[], 'alt'>;
}

const NewsFeedYear: React.FC<Props> = ({ year, items }) => (
  <div className="sm:flex self-stretch mt-6 first:mt-0 sm:rounded-lg overflow-hidden relative">
    <div className="bg-flprimary text-white text-center p-2 sm:p-1 antialiased text-xl font-sans tracking-widest flex items-center justify-center shrink-0">
      <div className="sm:-rotate-90 tracking-wider">{year}</div>
    </div>
    <div className="flex-grow">
      {items.map((item, idx) => (
        <NewsFeedItem
          key={`${item.title}${item.url}${item.type}${item.day}`}
          {...item}
          alt={idx % 2 !== 0}
        />
      ))}
    </div>
  </div>
);

export default NewsFeedYear;
