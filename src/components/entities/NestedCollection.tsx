import React, { useState } from 'react';
import cx from 'classnames';
import { ChevronRightIcon, PlusCircleIcon } from '@heroicons/react/solid';
import PillButton from '../PillButton';

interface Props<State extends { id: UUID }> {
  label: string;
  items: State[];
  onAdd(): unknown;
  renderItem: (item: State, index: number) => JSX.Element;
  startsCollapsed?: boolean;
}

export default function NestedCollection<State extends { id: UUID }>({
  renderItem,
  items,
  label,
  onAdd,
  startsCollapsed = true,
}: Props<State>) {
  const [isCollapsed, setIsCollapsed] = useState(startsCollapsed);
  return (
    <div className="bg-gray-100 rounded-lg p-4">
      <label
        className="label cursor-pointer"
        onClick={() => setIsCollapsed(!isCollapsed)}
      >
        <ChevronRightIcon
          className={cx(`inline mr-1 h-[20px] w-[20px]`, !isCollapsed && `rotate-90`)}
        />
        {label}s {items.length > 0 ? `(${items.length})` : ``}
      </label>
      <div className={cx(isCollapsed ? `hidden` : `mt-2`)}>
        <div className="pl-6 pt-2 divide-y divide-dashed divide-gray-300 space-y-6">
          {items.map((item, index) => (
            <div key={item.id} className="-mt-4 space-y-4">
              {renderItem(item, index)}
            </div>
          ))}
        </div>
        <div className="pt-4 flex justify-end">
          <PillButton Icon={PlusCircleIcon} className="ml-auto" onClick={onAdd}>
            Add {label}
          </PillButton>
        </div>
      </div>
    </div>
  );
}
