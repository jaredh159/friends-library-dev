import React from 'react';
import cx from 'classnames';

interface Props {
  onClick?: () => void;
  Icon?: React.FC<{ className?: string }>;
  className?: string;
  children: React.ReactNode;
}

const PillButton: React.FC<Props> = ({ onClick, Icon, children, className }) => {
  return (
    <button
      type="button"
      className={cx(
        className,
        `inline-flex items-center antialiased uppercase px-4 py-1.5 border border-transparent shadow-sm text-xs leading-4 font-medium rounded-full text-white bg-flprimary-500 hover:bg-flprimary-600 focus:outline-none focus:ring-1 focus:ring-offset-2 focus:ring-flprimary-500`,
      )}
      onClick={onClick}
    >
      {Icon && <Icon className="-ml-0.5 mr-1 h-4 w-4" aria-hidden="true" />}
      {children}
    </button>
  );
};

export default PillButton;
