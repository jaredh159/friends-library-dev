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
      `rounded-lg shadow-direct relative POPUNDER`, // REMOVE
      alignRight && `align-right`,
      `after:absolute after:top-0 after:left-[50%] after:w-0 after:h-0 after:[border:15px_solid_transparent] after:[border-bottom-color:currentColor] after:border-t-none after:ml-[-15px] after:mt-[-15px]`,
      `[&.align-right]:after:left-auto [&.align-right]:after:right-[19px]`,
    )}
  >
    {children}
  </div>
);

export default PopUnder;
