import React, { useState } from 'react';
import { gql } from '@apollo/client';
import cx from 'classnames';
import { v4 as uuid } from 'uuid';
import { XCircleIcon } from '@heroicons/react/solid';
import { OrderItem } from '../../types';
import { GetOrderEditions } from '../../graphql/GetOrderEditions';
import { useQueryResult } from '../../lib/query';
import { Lang } from '../../graphql/globalTypes';
import { printSizeVariantToPrintSize } from '../../lib/convert';

interface ContainerProps {
  onCancel: () => unknown;
  onSelect: (item: OrderItem) => unknown;
}

type Props = ContainerProps & {
  editions: Array<GetOrderEditions['editions'][0] & { searchString: string }>;
};

export const SelectBook: React.FC<Props> = ({ editions, onCancel, onSelect }) => {
  const [filterText, setFilterText] = useState(``);

  const filteredEditions = editions.filter((edition) => {
    if (filterText.length < 4) {
      return false;
    }
    const searchTerms = filterText.trim().toLowerCase().split(/\s+/g);
    for (const term of searchTerms) {
      if (!edition.searchString.includes(term)) {
        return false;
      }
    }
    return true;
  });

  return (
    <>
      <button className="absolute left-4 top-4" onClick={onCancel}>
        <XCircleIcon className="h-10 w-10 text-flprimary ring-flprimary hover:ring-2 rounded-full" />
      </button>
      <h1 className="text-flprimary font-sans font-bold text-2xl antialiased">
        Select a Book
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
      <div className="mt-3">
        <p className="font-mono text-gray-400 antialiased text-xs mb-2 ml-1">
          {filteredEditions.length} results
        </p>
        {filteredEditions.map((edition) => (
          <div key={edition.id} className="bg-[#efefef] rounded-md mb-3 py-1.5 flex pr-2">
            <img
              className="h-[161px] w-auto"
              width="110"
              height="161"
              alt={edition.document.trimmedUtf8ShortTitle}
              src={edition.images.threeD.large.url}
            />
            <div className="ml-2 space-y-1.5 mt-4">
              <h1 className="font-sans font-bold text-xl text-flprimary">
                {edition.document.trimmedUtf8ShortTitle}
              </h1>
              <h2 className="font-serif text-md antialiased text-gray-800">
                {edition.document.friend.name}
              </h2>
              <h3 className="font-serif text-md">
                <span
                  className={cx(`capitalize`, {
                    'text-flmaroon':
                      edition.type === `updated` && edition.document.friend.lang === `en`,
                    'text-flgold':
                      edition.type === `updated` && edition.document.friend.lang === `es`,
                    'text-flblue': edition.type === `modernized`,
                    'text-flgreen': edition.type === `original`,
                  })}
                >
                  {edition.type}
                </span>
                {` `}
                edition
              </h3>
            </div>
            <button
              onClick={() => {
                onSelect({
                  id: uuid(),
                  lang: edition.document.friend.lang,
                  editionId: edition.id,
                  image: edition.images.threeD.small.url,
                  orderTitle: `${edition.document.title}${
                    edition.type !== `updated` ? ` (${edition.type})` : ``
                  }`,
                  displayTitle: edition.document.trimmedUtf8ShortTitle,
                  author: edition.document.friend.name,
                  quantity: 1,
                  unitPrice: edition.impression!.paperbackPriceInCents,
                  printSize: printSizeVariantToPrintSize(
                    edition.impression!.paperbackSize,
                  ),
                  pages: edition.impression!.paperbackVolumes,
                });
              }}
              className="ml-auto whitespace-no-wrap flex-shrink-0 bg-flblue-600 hover:ring-2 ring-offset-2 ring-flblue-400 cursor-pointer mr-2 antialiased uppercase text-xs self-end mb-4 rounded-full text-white px-4 py-1"
            >
              Add to Order +
            </button>
          </div>
        ))}
      </div>
    </>
  );
};

// container

const SelectBookContainer: React.FC<ContainerProps> = ({ onCancel, onSelect }) => {
  const query = useQueryResult<GetOrderEditions>(QUERY_ORDER_EDITIONS);
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  const editions = query.data.editions
    .map((ed) => ({ ...ed, searchString: editionSearchString(ed) }))
    .filter((ed) => !ed.isDraft)
    .filter((ed) => !!ed.impression);
  return <SelectBook onCancel={onCancel} onSelect={onSelect} editions={editions} />;
};

export default SelectBookContainer;

const QUERY_ORDER_EDITIONS = gql`
  query GetOrderEditions {
    editions: getEditions {
      id
      type
      isDraft
      document {
        title
        trimmedUtf8ShortTitle
        friend {
          name
          lang
        }
      }
      impression {
        paperbackPriceInCents
        paperbackSize
        paperbackVolumes
      }
      images {
        threeD {
          small: w55 {
            url
          }
          large: w110 {
            url
          }
        }
      }
    }
  }
`;

function editionSearchString(edition: GetOrderEditions['editions'][0]): string {
  return [
    edition.document.title,
    edition.document.friend.name,
    edition.type,
    edition.document.friend.lang === Lang.en ? `english` : `spanish espanol`,
  ]
    .join(` `)
    .toLowerCase();
}
