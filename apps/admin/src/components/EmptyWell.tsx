import React from 'react';
import cx from 'classnames';

interface Props {
  className?: string;
  small?: boolean;
}

const EmptyWell: React.FC<Props> = ({ className, children, small }) => {
  return (
    <div
      className={cx(
        className,
        `flex items-center justify-center antialiased border-4 text-gray-400 bg-flgreen/5 border-dashed rounded-2xl bg-opacity-50 text-center leading-7`,
        small ? `text-sm leading-5` : `leading-7`,
      )}
    >
      <span className={cx(small ? `my-8 mx-20` : `my-16 mx-24`)}>{children}</span>
    </div>
  );
};

export default EmptyWell;
