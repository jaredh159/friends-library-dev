import React from 'react';
import cx from 'classnames';
import Toggle from './Toggle';

interface Props {
  label: string;
  enabled: boolean;
  setEnabled: (enabled: boolean) => unknown;
  small?: boolean;
  className?: string;
  toggleClassName?: string;
}

const LabeledToggle: React.FC<Props> = ({
  label,
  enabled,
  setEnabled,
  small,
  className,
  toggleClassName,
}) => (
  <div className={cx(`flex flex-col justify-between`, className)}>
    <label className="label">{label}</label>
    <Toggle
      small={small ?? false}
      className={cx(`self-center mb-1.5`, toggleClassName)}
      enabled={enabled}
      setEnabled={setEnabled}
    />
  </div>
);

export default LabeledToggle;
