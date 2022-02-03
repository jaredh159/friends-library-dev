import React, { useState } from 'react';
import cx from 'classnames';
import { ChevronRightIcon, PlusCircleIcon } from '@heroicons/react/solid';
import PillButton from '../PillButton';
import { Link } from 'react-router-dom';

interface Props<State extends { id: UUID }> {
  label: string;
  items: State[];
  onAdd(): unknown;
  onDelete(index: number): unknown;
  renderItem: (item: State, index: number) => JSX.Element;
  startsCollapsed?: boolean;
  editLink?: string;
}

export default function NestedCollection<State extends { id: UUID }>({
  renderItem,
  items,
  label,
  onAdd,
  onDelete,
  editLink,
  startsCollapsed = true,
}: Props<State>): JSX.Element {
  const [isCollapsed, setIsCollapsed] = useState(startsCollapsed);
  const collapsed = isCollapsed || items.length === 0;
  return (
    <div className="bg-gray-100 rounded-lg p-4 relative">
      <label
        className="label cursor-pointer"
        onClick={() => setIsCollapsed(!isCollapsed)}
      >
        <ChevronRightIcon
          className={cx(
            `inline mr-1 h-[20px] w-[20px]`,
            !isCollapsed && `rotate-90`,
            items.length === 0 && `hidden`,
          )}
        />
        {items.length === 0 ? `No ${label}s` : `${label}s (${items.length})`}
      </label>
      <div className={cx(collapsed ? `hidden` : `mt-2`)}>
        <div className="pl-6 pt-2 divide-y divide-dashed divide-gray-300 space-y-5 -mt-8">
          {items.map((item, index) => (
            <div key={item.id} className="mt-4 pt-4 pb-2 relative group">
              {renderItem(item, index)}
              {editLink && (
                <Link
                  className="transition absolute -bottom-3 right-12 opacity-0 group-hover:opacity-100 hover:opacity-100 hover:text-gray-800 cursor-pointer text-[10px] text-gray-700/50 antialiased uppercase"
                  to={editLink.replace(`:id`, item.id)}
                >
                  Isolate
                </Link>
              )}
              <span
                onClick={() => onDelete(index)}
                className="transition absolute -bottom-3 right-0 opacity-0 group-hover:opacity-100 hover:opacity-100 hover:text-red-800 cursor-pointer text-[10px] text-red-700/50 antialiased uppercase"
              >
                Delete
              </span>
            </div>
          ))}
          <div className={cx(`pt-4 flex justify-end`)}>
            <PillButton Icon={PlusCircleIcon} className="ml-auto" onClick={onAdd}>
              Add {label}
            </PillButton>
          </div>
        </div>
      </div>
      <div
        className={cx(
          items.length > 0 && `hidden`,
          `absolute right-0 top-0 mt-[11.5px] mr-3`,
        )}
      >
        <PillButton Icon={PlusCircleIcon} className="ml-auto" onClick={onAdd}>
          Add
        </PillButton>
      </div>
    </div>
  );
}
