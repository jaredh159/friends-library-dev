import React from 'react';
import cx from 'classnames';
import { Link, useNavigate } from 'react-router-dom';
import { PlusCircleIcon } from '@heroicons/react/solid';
import { useFetchResult } from '../../lib/query';
import api, { type T } from '../../api-client';
import { Scope as TokenScope } from '../../graphql/globalTypes';
import PillButton from '../PillButton';

interface Props {
  tokens: T.ListTokens.Output;
}

const ListTokens: React.FC<Props> = ({ tokens }) => {
  const navigate = useNavigate();
  return (
    <div className="space-y-3">
      {tokens.map((token) => {
        const hasAllScopes = token.scopes.some((scope) => scope.type === TokenScope.all);
        return (
          <Link
            to={`/tokens/${token.id}`}
            key={token.id}
            className="flex space-x-4 items-center bg-gray-100/75 hover:bg-blue-100/50 rounded-lg p-3"
          >
            <span className="label w-[9%]">
              {new Date(token.createdAt).toLocaleDateString()}
            </span>
            <span
              className={cx(
                hasAllScopes ? `bg-flgold` : `bg-flprimary`,
                `text-white text-[9px] rounded-full w-4 h-4 flex items-center justify-center`,
              )}
            >
              <span>{hasAllScopes ? `A` : token.scopes.length}</span>
            </span>

            <span className="label pl-2">Description:</span>
            <span className="subtle-text flex-grow truncate">{token.description}</span>
          </Link>
        );
      })}
      <div className="flex justify-end">
        <PillButton
          onClick={() => navigate(`/tokens/new`)}
          className="mb-1 mt-4"
          Icon={PlusCircleIcon}
        >
          Add New Token
        </PillButton>
      </div>
    </div>
  );
};

const ListTokensContainer: React.FC = () => {
  const query = useFetchResult(() => api.listTokensResult());
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  query.data.sort((a, b) => (a.createdAt < b.createdAt ? 1 : -1));
  return <ListTokens tokens={query.data} />;
};

export default ListTokensContainer;
