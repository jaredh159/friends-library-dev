import React, { useState } from 'react';
import cx from 'classnames';
import { ReducerReplace, EditableEdition } from '../../types';
import { EditionType, PrintSize } from '../../graphql/globalTypes';
import LabeledSelect from '../LabeledSelect';
import LabeledToggle from '../LabeledToggle';
import TextInput from '../TextInput';

interface Props {
  edition: EditableEdition;
  replace: ReducerReplace;
}

const EditEdition: React.FC<Props> = ({ edition, replace }) => {
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
      <LabeledSelect
        label="Override Size:"
        selected={edition.paperbackOverrideSize ?? ``}
        setSelected={replace(`paperbackOverrideSize`, (size) =>
          size === `` ? null : size,
        )}
        options={[
          [``, `(not set)`],
          [PrintSize.s, `small`],
          [PrintSize.m, `medium`],
          [PrintSize.xl, `larg`],
        ]}
      />
      <TextInput
        type="text"
        label="Splits:"
        className="w-1/6"
        value={splits}
        isValid={(str) => {
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
      <TextInput
        type="text"
        label="ISBN:"
        className={cx(`w-[27%]`, !edition.isbn && `opacity-0`)}
        disabled
        value={edition.isbn?.code ?? ``}
        onChange={() => {}}
      />
    </div>
  );
};

export default EditEdition;
