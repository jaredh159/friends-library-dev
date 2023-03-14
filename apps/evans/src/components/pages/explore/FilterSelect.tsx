import React from 'react';
import { t } from '@friends-library/locale';
import PillDropdown from '../../PillDropdown';
import FilterSelectDropdown from './FilterSelectDropdown';

interface Props {
  selected: string[];
  setSelected: (selected: string[]) => any;
}

const FilterSelect: React.FC<Props> = ({ selected, setSelected }) => (
  <PillDropdown pillText={t`All Books`}>
    <FilterSelectDropdown selected={selected} setSelected={setSelected} />
  </PillDropdown>
);

export default FilterSelect;
