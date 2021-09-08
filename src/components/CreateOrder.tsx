import React, { useState, useEffect } from 'react';
import { AppEditionResourceV1 as Edition } from '@friends-library/api';
import Loading from './Loading';
import * as api from '../lib/api';

const CreateOrder: React.FC = () => {
  let initialEditions: Edition[] | null = null;
  const storedEditionsJson: string | null = sessionStorage.getItem(`editions`);
  if (storedEditionsJson) {
    initialEditions = JSON.parse(storedEditionsJson);
  }

  const [editions, setEditions] = useState<Edition[] | null>(initialEditions);
  const [filterText, setFilterText] = useState(`turford`);

  useEffect(() => {
    if (editions === null) {
      api.getEditions().then((editions) => {
        sessionStorage.setItem(`editions`, JSON.stringify(editions));
        setEditions(editions);
      });
    }
  }, [editions]);

  if (editions === null) {
    return (
      <div className="w-full h-screen flex items-center justify-center">
        <Loading />
      </div>
    );
  }

  const filteredEditions = editions.filter((edition) => {
    if (filterText.length < 4) {
      return false;
    }
    const searchIn = [edition.document.title, edition.friend.name, edition.type]
      .join(` `)
      .toLowerCase()
      .split(/\s+/g);

    const searchTerms = filterText.trim().toLowerCase().split(/\s+/g);

    // still bad, not getting partial matches like `cath`
    for (const term of searchTerms) {
      if (!searchIn.includes(term)) {
        return false;
      }
    }
    return true;
  });

  return (
    <div
      className="flex flex-col items-center p-12 bg-[#efefef]"
      style={{ minHeight: `100vh` }}
    >
      <div className="w-1/2 min-w-[600px]">
        <h1 className="text-flprimary font-sans font-bold text-2xl antialiased">
          Create an Order:
        </h1>
        <div className="flex justify-between mt-4">
          <label htmlFor="email" className="block text-sm font-medium text-gray-700">
            Enter text to select a book:
          </label>
        </div>
        <div className="mt-1">
          <input
            type="text"
            className="shadow-sm focus:ring-flprimary-500 focus:border-flprimary-500 block w-full sm:text-sm border-gray-300 rounded-md placeholder-gray-300"
            placeholder="e.g: No Cross No Crown, Hugh Turford, La Senda Antigua ..."
            value={filterText}
            onChange={(event) => setFilterText(event.target.value)}
          />
        </div>
        <div className="mt-2">
          {filteredEditions.map((edition) => (
            <div key={edition.id}>
              <img alt={edition.document.title} src={edition.images.threeD[1]?.url} />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default CreateOrder;
