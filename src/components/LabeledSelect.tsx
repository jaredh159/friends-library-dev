import React from 'react';

interface Props {
  label: string;
  selected: string;
  setSelected: (newValue: string) => unknown;
  options: Array<[value: string, display: string]>;
  className?: string;
}

const LabeledSelect: React.FC<Props> = ({
  label,
  selected,
  setSelected,
  options,
  className,
}) => (
  <div className={className}>
    <label className="block text-sm text-flprimary-500 antialiased">{label}</label>
    <select
      className="mt-1 w-full block pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-blue-500 focus:border-blue-500 sm:text-sm rounded-md"
      value={selected}
      onChange={(e) => setSelected(e.target.value)}
    >
      {options.map(([value, display]) => (
        <option key={value} value={value}>
          {display}
        </option>
      ))}
    </select>
  </div>
);

export default LabeledSelect;
