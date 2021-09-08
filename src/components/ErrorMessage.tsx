import React from 'react';
import cx from 'classnames';

interface Props {
  className?: string;
}

const ErrorMessage: React.FC<Props> = ({ className, children }) => (
  <p
    className={cx(
      `bg-red-200 text-red-900 text-center antialiased text-sm p-2 rounded-md`,
      className,
    )}
  >
    {children ?? `Unexpected error`}
  </p>
);

export default ErrorMessage;
