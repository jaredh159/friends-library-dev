import React from 'react';
import cx from 'classnames';

interface Props {
  id: string;
  label: string;
  checked: boolean;
  onToggle(value: boolean): unknown;
  className?: string;
}

const LabledCheckbox: React.FC<Props> = ({ id, label, onToggle, checked, className }) => {
  return (
    <label
      className={cx(
        `text-xs text-gray-500 cursor-pointer hover:text-gray-700`,
        className,
      )}
      htmlFor={id}
    >
      <input
        className="border-px border-gray-300 hover:border-flprimary-500 rounded-sm mr-1.5 -translate-y-px text-flprimary-500 focus:outline-none focus:ring-transparent"
        onChange={(event) => {
          onToggle(event.target.checked);
        }}
        type="checkbox"
        checked={checked}
        id={id}
        name={id}
      />
      {label}
    </label>
  );
};

export default LabledCheckbox;
