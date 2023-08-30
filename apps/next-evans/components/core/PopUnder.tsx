import React from 'react';
import cx from 'classnames';

interface Props {
  tailwindBgColor?: string;
  className?: string;
  style?: Record<string, string | number>;
  alignRight?: boolean;
  children: React.ReactNode;
}

const PopUnder: React.FC<Props> = ({
  className,
  children,
  alignRight,
  style,
  tailwindBgColor = `white`,
}) => (
  <div
    {...(style ? { style } : {})}
    className={cx(
      className,
      `bg-${tailwindBgColor}`,
      `text-${tailwindBgColor}`,
      `rounded-lg shadow-direct relative flex flex-col`,
      alignRight && `align-right`,
      `after:w-6 after:h-6 after:bg-flblue after:absolute after:-top-2 after:rotate-45 z-10 after:left-[calc(50%-10px)]`,
    )}
  >
    {children}
  </div>
);

export default PopUnder;
