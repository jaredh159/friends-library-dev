import { gql } from '@apollo/client';
import cx from 'classnames';
import React, { useState } from 'react';
import { useQueryResult } from '../../lib/query';
import { GetFriends } from '../../graphql/GetFriends';
import { Lang } from '../../graphql/globalTypes';
import TextInput from '../TextInput';
import { Link } from 'react-router-dom';

interface Props {
  friends: GetFriends['friends'];
}

const ListFriends: React.FC<Props> = ({ friends }) => {
  const [filterText, setFilterText] = useState(``);
  const filteredFriends = friends.filter((friend) => {
    if (filterText.length < 3) {
      return true;
    }
    const searchTerms = filterText.trim().toLowerCase().split(/\s+/g);
    for (const term of searchTerms) {
      if (!friend.name.toLowerCase().includes(term)) {
        return false;
      }
    }
    return true;
  });
  return (
    <div className="h-screen">
      <TextInput
        type="text"
        label="Filter:"
        value={filterText}
        onChange={setFilterText}
        autoFocus
        className="my-4"
      />
      <div className="grid grid-cols-3">
        {filteredFriends.map((friend) => (
          <Link
            key={friend.id}
            to={`/friends/${friend.id}`}
            className={cx(
              friend.lang === Lang.en
                ? `text-flmaroon ring-flmaroon/75`
                : `text-flgold ring-flgold/75`,
              `mx-2 focus:outline-none focus:ring-2 px-1 rounded-md`,
            )}
          >
            {friend.alphabeticalName}
          </Link>
        ))}
      </div>
    </div>
  );
};

// container

const ListFriendsContainer: React.FC = () => {
  const query = useQueryResult<GetFriends>(QUERY_FRIENDS);
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  return (
    <ListFriends
      friends={[...query.data.friends].sort((a, b) =>
        a.alphabeticalName < b.alphabeticalName ? -1 : 1,
      )}
    />
  );
};

export default ListFriendsContainer;

const QUERY_FRIENDS = gql`
  query GetFriends {
    friends: getFriends {
      id
      name
      alphabeticalName
      lang
    }
  }
`;
