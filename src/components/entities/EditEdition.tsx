import React, { useState } from 'react';
import cx from 'classnames';
import { ReducerReplace, EditableEdition } from '../../types';
import { EditionType, Lang, PrintSize } from '../../graphql/globalTypes';
import LabeledSelect from '../LabeledSelect';
import LabeledToggle from '../LabeledToggle';
import TextInput from '../TextInput';

interface Props {
  edition: EditableEdition;
  replace: ReducerReplace;
  lang: Lang;
}

const EditEdition: React.FC<Props> = ({ edition, replace, lang }) => {
  const [splits, setSplits] = useState(
    edition.paperbackSplits ? JSON.stringify(edition.paperbackSplits) : ``,
  );

  function updateSplits(value: string): void {
    setSplits(value);
    try {
      const parsed = JSON.parse(value);
      if (Array.isArray(parsed) && parsed.every((i) => Number.isInteger(i))) {
        replace(`paperbackSplits`)(parsed);
      }
    } catch {
      replace(`paperbackSplits`)(null);
    }
  }

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
            [EditionType.updated, EditionType.updated],
            [EditionType.modernized, EditionType.modernized],
            [EditionType.original, EditionType.original],
          ]}
        />

        <TextInput
          type="text"
          label="ISBN:"
          className={cx(`w-[42.5%]`, !edition.isbn && `opacity-0`)}
          disabled
          value={edition.isbn?.code ?? ``}
          onChange={() => {}}
        />
      </div>
      <div className="flex space-x-4">
        <TextInput
          type="text"
          label="Editor:"
          className="flex-grow"
          disabled={edition.type !== EditionType.updated || lang === Lang.es}
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
            [PrintSize.s, `small`],
            [PrintSize.m, `medium`],
            [PrintSize.xl, `large`],
          ]}
        />
        <TextInput
          type="text"
          label="Splits:"
          className="w-1/5"
          value={splits}
          isValid={(str) => {
            if (str.trim() === ``) {
              return true;
            }
            try {
              const parsed = JSON.parse(str);
              return (
                Array.isArray(parsed) &&
                parsed.every((i) => typeof i === `number` && Number.isInteger(i))
              );
            } catch {
              return false;
            }
          }}
          onChange={updateSplits}
        />
      </div>
    </div>
  );
};

export default EditEdition;
