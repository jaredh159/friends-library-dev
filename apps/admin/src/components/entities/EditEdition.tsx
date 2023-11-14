import React, { useState } from 'react';
import cx from 'classnames';
import { PlusCircleIcon } from '@heroicons/react/solid';
import type { Lang } from '@friends-library/types';
import type { ReducerReplace } from '../../types';
import { type T } from '../../api-client';
import LabeledSelect from '../LabeledSelect';
import LabeledToggle from '../LabeledToggle';
import TextInput from '../TextInput';
import * as empty from '../../lib/empty';
import PillButton from '../PillButton';
import * as nonEmptyIntArray from './non-empty-int-array';
import { EditAudio } from './EditAudio';

interface Props {
  edition: T.EditableEdition;
  replace: ReducerReplace;
  lang: Lang;
}

const EditEdition: React.FC<Props> = ({ edition, replace, lang }) => {
  const [splits, setSplits] = useState(
    edition.paperbackSplits ? JSON.stringify(edition.paperbackSplits) : ``,
  );

  const updateSplits = nonEmptyIntArray.makeUpdater(
    setSplits,
    replace(`paperbackSplits`),
  );

  return (
    <div className="space-y-4">
      <div className="flex space-x-4">
        <LabeledToggle
          label="Draft:"
          enabled={edition.isDraft}
          setEnabled={replace(`isDraft`)}
        />
        <LabeledSelect
          label="Type:"
          className="flex-grow"
          selected={edition.type}
          setSelected={replace(`type`)}
          options={[
            [`updated`, `updated`],
            [`modernized`, `modernized`],
            [`original`, `original`],
          ]}
        />

        <TextInput
          type="text"
          label="ISBN:"
          className={cx(`w-[42.5%]`, !edition.isbn && `opacity-0`)}
          disabled
          value={edition.isbn ?? ``}
          onChange={() => {}}
        />
      </div>
      <div className="flex space-x-4">
        <TextInput
          type="text"
          label="Editor:"
          className="flex-grow"
          disabled={edition.type !== `updated` || lang === `es`}
          value={edition.editor ?? ``}
          onChange={replace(`editor`, (ed) => (ed === `` ? null : ed))}
        />
        <LabeledSelect
          label="Override Size:"
          className="w-1/5"
          selected={edition.paperbackOverrideSize ?? ``}
          setSelected={replace(`paperbackOverrideSize`, (size) =>
            size === `` ? null : size,
          )}
          options={[
            [``, `(not set)`],
            [`s`, `small`],
            [`m`, `medium`],
            [`xl`, `large`],
          ]}
        />
        <TextInput
          type="text"
          label="Splits:"
          className="w-1/5"
          value={splits}
          isValid={nonEmptyIntArray.makeValidator({ canBeNull: true })}
          onChange={updateSplits}
        />
      </div>
      {edition.audio ? (
        <EditAudio
          audio={edition.audio}
          replace={(path, preprocess) => replace(`audio.${path}`, preprocess)}
        />
      ) : (
        <div className="flex space-between items-center py-2">
          <span className="label">No Audio</span>
          <PillButton
            Icon={PlusCircleIcon}
            className="ml-auto"
            onClick={() => replace(`audio`)(empty.audio(edition.id))}
          >
            Add Audio
          </PillButton>
        </div>
      )}
    </div>
  );
};

export default EditEdition;
