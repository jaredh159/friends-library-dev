import { gql } from '@apollo/client';
import cx from 'classnames';
import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import type { GetDocuments } from '../../graphql/GetDocuments';
import { useQueryResult } from '../../lib/query';
import { Lang } from '../../graphql/globalTypes';
import TextInput from '../TextInput';

interface Props {
  documents: GetDocuments['documents'];
}

const ListDocuments: React.FC<Props> = ({ documents }) => {
  const [filterText, setFilterText] = useState(``);
  const filteredDocs = documents.filter((document) => {
    if (filterText.length < 3) {
      return true;
    }
    const searchText = [document.friend.name, document.title].join(` `);
    const searchTerms = filterText.trim().toLowerCase().split(/\s+/g);
    for (const term of searchTerms) {
      if (!searchText.toLowerCase().includes(term)) {
        return false;
      }
    }
    return true;
  });
  return (
    <div className="h-screen">
      <TextInput
        type="text"
        label=""
        placeholder="filter documents..."
        value={filterText}
        onChange={setFilterText}
        autoFocus
        className="my-4"
      />
      <div>
        {filteredDocs.map((doc) => (
          <Link
            key={doc.id}
            to={`/documents/${doc.id}`}
            className={cx(
              doc.friend.lang === Lang.en
                ? `text-flmaroon ring-flmaroon/75`
                : `text-flgold ring-flgold/75`,
              `block mx-2 focus:outline-none focus:ring-2 px-1 rounded-md`,
            )}
          >
            {doc.friend.alphabeticalName.replace(/, ?$/, ``)}: {doc.title}
          </Link>
        ))}
      </div>
    </div>
  );
};

// container

const ListDocumentsContainer: React.FC = () => {
  const query = useQueryResult<GetDocuments>(QUERY_DOCUMENTS);
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  return (
    <ListDocuments
      documents={[...query.data.documents].sort((a, b) => {
        if (a.friend.alphabeticalName === b.friend.alphabeticalName) {
          return a.title < b.title ? -1 : 1;
        } else {
          return a.friend.alphabeticalName < b.friend.alphabeticalName ? -1 : 1;
        }
      })}
    />
  );
};

export default ListDocumentsContainer;

const QUERY_DOCUMENTS = gql`
  query GetDocuments {
    documents: getDocuments {
      id
      title
      friend {
        name
        alphabeticalName
        lang
      }
    }
  }
`;
