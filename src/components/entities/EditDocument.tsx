import React, { useReducer, useState } from 'react';
import { ReducerReplace, Reducer, EditableDocument } from '../../types';
import TextInput from '../TextInput';
import { gql } from '@apollo/client';
import { EDIT_DOCUMENT_FIELDS } from '../../client';
import { useParams } from 'react-router-dom';
import { useQueryResult } from '../../lib/query';
import {
  EditDocument as EditDocumentQuery,
  EditDocumentVariables as Vars,
} from '../../graphql/EditDocument';
import reducer from './reducer';
import { Lang } from '../../graphql/globalTypes';
import NestedCollection from './NestedCollection';
import LabeledToggle from '../LabeledToggle';
import EditEdition from './EditEdition';
import * as emptyEntities from '../../lib/empty-entities';

interface Props {
  document: EditableDocument;
  replace: ReducerReplace;
  deleteItem(path: string): unknown;
  addItem(path: string, item: unknown): unknown;
}

export const EditDocument: React.FC<Props> = ({
  document: doc,
  replace,
  addItem,
  deleteItem,
}) => {
  return (
    <div className="space-y-4">
      <div className="flex space-x-4">
        <TextInput
          type="text"
          label="Author:"
          value={doc.friend.name}
          disabled
          isValid={(slug) => slug.length > 3 && !!slug.match(/^([a-z-]+)$/)}
          invalidMessage="min length 3, only lowercase letters and dashes"
          onChange={replace(`slug`)}
          className="w-1/2"
        />
        <TextInput
          type="text"
          label={`${doc.friend.lang === Lang.en ? `Spanish` : `Enlish`} Document ID:`}
          value={doc.altLanguageId}
          isValid={(fn) => !!fn.match(/^[A-Z][A-Za-z0-9_]+$/)}
          invalidMessage="Letters, numbers, and underscores only"
          onChange={replace(`filename`)}
          className="w-1/2"
        />
      </div>
      <div className="flex space-x-4">
        <TextInput
          type="text"
          label="Title:"
          value={doc.title}
          onChange={replace(`title`)}
          className="flex-grow"
        />
        <TextInput
          type="number"
          label="Published:"
          placeholder="1600"
          value={String(doc.published ?? ``)}
          onChange={replace(`published`)}
          className="w-[12%]"
        />
        <LabeledToggle
          label="Incomplete:"
          enabled={doc.incomplete}
          setEnabled={replace(`incomplete`)}
        />
      </div>
      <div className="flex space-x-4">
        <TextInput
          type="text"
          label="Slug:"
          value={doc.slug}
          isValid={(slug) => slug.length > 3 && !!slug.match(/^([a-z-]+)$/)}
          invalidMessage="min length 3, only lowercase letters and dashes"
          onChange={replace(`slug`)}
          className="w-1/2"
        />
        <TextInput
          type="text"
          label="Filename:"
          value={doc.filename}
          isValid={(fn) => !!fn.match(/^[A-Z][A-Za-z0-9_]+$/)}
          invalidMessage="Letters, numbers, and underscores only"
          onChange={replace(`filename`)}
          className="w-1/2"
        />
      </div>
      <TextInput
        type="textarea"
        textareaSize="h-24"
        label="Original Title:"
        value={doc.originalTitle}
        onChange={replace(`originalTitle`)}
      />
      <TextInput
        type="textarea"
        textareaSize="h-[12em]"
        label="Description"
        value={doc.description}
        onChange={replace(`description`)}
      />
      <TextInput
        type="textarea"
        textareaSize="h-24"
        label="Partial Description:"
        value={doc.partialDescription}
        onChange={replace(`partialDescription`)}
      />
      <TextInput
        type="textarea"
        textareaSize="h-24"
        label="Featured Description:"
        value={doc.featuredDescription}
        onChange={replace(`featuredDescription`)}
      />
      <NestedCollection
        label="Edition"
        items={doc.editions}
        startsCollapsed={false}
        onAdd={() => addItem(`editions`, emptyEntities.edition())}
        onDelete={(index) => deleteItem(`editions[${index}]`)}
        renderItem={(item, index) => (
          <EditEdition
            edition={item}
            replace={(path) => replace(`editions[${index}].${path}`)}
          />
        )}
      />
    </div>
  );
};

// container

const EditDocumentContainer: React.FC = () => {
  const { id = `` } = useParams<{ id: UUID }>();
  const [loaded, setLoaded] = useState(false);
  const [document, dispatch] = useReducer<Reducer<EditableDocument>>(
    reducer,
    null as any,
  );
  const query = useQueryResult<EditDocumentQuery, Vars>(QUERY_DOCUMENT, {
    variables: { id },
  });

  if (!query.isResolved) {
    return query.unresolvedElement;
  }

  if (!loaded) {
    setLoaded(true);
    dispatch({ type: `replace`, state: query.data.document });
  }

  return (
    <EditDocument
      document={document}
      deleteItem={(path) => dispatch({ type: `delete_item`, at: path })}
      addItem={(path, item) => dispatch({ type: `add_item`, at: path, value: item })}
      replace={(path, preprocess) => (value) =>
        dispatch({
          type: `replace_value`,
          at: path,
          with: preprocess ? preprocess(value) : value,
        })}
    />
  );
};

export default EditDocumentContainer;

const QUERY_DOCUMENT = gql`
  ${EDIT_DOCUMENT_FIELDS}
  query EditDocument($id: UUID!) {
    document: getDocument(id: $id) {
      ...EditDocumentFields
    }
  }
`;
