import React from 'react';
import cx from 'classnames';
import { Switch } from '@headlessui/react';

interface Props {
  enabled: boolean;
  setEnabled: (enabled: boolean) => unknown;
  small?: boolean;
  className?: string;
}

const Toggle: React.FC<Props> = ({ enabled, setEnabled, small, className }) => (
  <Switch
    checked={enabled}
    onChange={setEnabled}
    className={cx(
      enabled ? `bg-flprimary-600` : `bg-gray-200`,
      small ? `h-5 w-9` : `h-6 w-11`,
      `relative inline-flex flex-shrink-0 border-2 border-transparent rounded-full cursor-pointer transition-colors ease-in-out duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-flprimary-500`,
      className,
    )}
  >
    <span
      aria-hidden="true"
      className={cx(
        enabled ? (small ? `translate-x-4` : `translate-x-5`) : `translate-x-0`,
        small ? `h-4 w-4` : `h-5 w-5`,
        `pointer-events-none inline-block rounded-full bg-white shadow transform ring-0 transition ease-in-out duration-200`,
      )}
    />
  </Switch>
);

export default Toggle;
