import React, { Reducer, useReducer } from 'react';
import { v4 as uuid } from 'uuid';
import { useParams } from 'react-router-dom';
import { gql } from '@apollo/client';
import { useQueryResult } from '../../lib/query';
import {
  EditFriend as EditFriendQuery,
  EditFriendVariables,
} from '../../graphql/EditFriend';
import TextInput from '../TextInput';
import LabeledSelect from '../LabeledSelect';
import { Gender } from '../../graphql/globalTypes';
import reducer, { isValidYear, Action } from './reducer';
import NestedCollection from './NestedCollection';
import { EditDocument } from './EditDocument';
import { EDIT_DOCUMENT_FIELDS } from '../../client';

interface Props {
  friend: EditFriendQuery['friend'];
}

type Friend = EditFriendQuery['friend'];

export const EditFriend: React.FC<Props> = ({ friend }) => {
  const [state, dispatch] = useReducer<Reducer<Friend, Action<Friend>>>(reducer, friend);
  const replace: (path: string) => (value: unknown) => unknown = (path) => {
    return (value) => dispatch({ type: `replace_value`, at: path, with: value });
  };
  const deleteFrom: (path: string) => (index: number) => unknown = (path) => {
    return (index) => dispatch({ type: `delete_item`, at: `${path}[${index}]` });
  };
  return (
    <div className="mt-6 space-y-4">
      <div className="flex space-x-4">
        <TextInput
          type="text"
          label="Name:"
          isValid={(name) => name.length > 5 && !!name.match(/^[A-Z].* [A-Z].*/)}
          invalidMessage="min length 5, first + last at least"
          value={state.name}
          onChange={replace(`name`)}
          className="flex-grow"
        />
        <TextInput
          type="text"
          label="Slug:"
          isValid={(slug) => slug.length > 5 && !!slug.match(/^([a-z-]+)$/)}
          invalidMessage="min length 5, only lowercase letters and dashes"
          value={state.slug}
          onChange={replace(`slug`)}
          className="flex-grow"
        />
      </div>
      <div className="flex space-x-4">
        <LabeledSelect
          label="Gender:"
          selected={state.gender}
          setSelected={replace(`gender`)}
          options={[
            [Gender.male, `male`],
            [Gender.female, `female`],
            [Gender.mixed, `mixed (compilations)`],
          ]}
          className="w-1/2"
        />
        <div className="flex w-1/2 space-x-4">
          <TextInput
            type="number"
            label="Born:"
            isValid={isValidYear}
            value={state.born === null ? `` : String(state.born)}
            onChange={(year) => dispatch({ type: `update_year`, at: `born`, with: year })}
            className="w-1/2"
          />
          <TextInput
            type="number"
            label="Died:"
            isValid={isValidYear}
            value={state.died === null ? `` : String(state.died)}
            onChange={(year) => dispatch({ type: `update_year`, at: `died`, with: year })}
            className="w-1/2"
          />
        </div>
      </div>
      <TextInput
        type="textarea"
        label="Description:"
        value={state.description}
        onChange={replace(`description`)}
      />
      <NestedCollection
        label="Quote"
        items={state.quotes}
        startsCollapsed={true}
        onDelete={deleteFrom(`quotes`)}
        onAdd={() =>
          dispatch({
            type: `add_item`,
            at: `quotes`,
            value: {
              id: uuid(),
              source: ``,
              text: ``,
              order: Math.max(0, ...state.quotes.map((q) => q.order)) + 1,
            },
          })
        }
        renderItem={(item, index) => (
          <div className="space-y-4">
            <div className="flex space-x-4">
              <TextInput
                type="text"
                className="flex-grow"
                label={`Quote Source:`}
                value={item.source}
                onChange={replace(`quotes[${index}].source`)}
              />
              <TextInput
                type="number"
                label={`Quote Order:`}
                isValid={(input) => Number.isInteger(Number(input))}
                value={String(item.order)}
                onChange={replace(`quotes[${index}].order`)}
              />
            </div>
            <TextInput
              type="textarea"
              textareaSize="h-32"
              label="Quote Text:"
              value={state.quotes[index]?.text ?? ``}
              onChange={replace(`quotes[${index}].text`)}
            />
          </div>
        )}
      />
      <NestedCollection
        label="Document"
        items={state.documents.slice(0, 2)}
        onAdd={() => {}}
        onDelete={deleteFrom(`documents`)}
        startsCollapsed={false}
        editLink="/documents/:id"
        renderItem={(item, index) => (
          <EditDocument
            document={item}
            replace={(path) => (value) =>
              dispatch({
                type: `replace_value`,
                at: `documents[${index}].${path}`,
                with: value,
              })}
          />
        )}
      />
    </div>
  );
};

// container

const EditFriendContainer: React.FC = () => {
  const { id = `` } = useParams<{ id: UUID }>();
  const query = useQueryResult<EditFriendQuery, EditFriendVariables>(QUERY_FRIEND, {
    variables: { id },
  });
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  return <EditFriend friend={query.data.friend} />;
};

export default EditFriendContainer;

const QUERY_FRIEND = gql`
  ${EDIT_DOCUMENT_FIELDS}
  query EditFriend($id: UUID!) {
    friend: getFriend(id: $id) {
      name
      slug
      gender
      born
      died
      description
      quotes {
        id
        source
        text
        order
      }
      documents {
        ...EditDocumentFields
      }
    }
  }
`;
