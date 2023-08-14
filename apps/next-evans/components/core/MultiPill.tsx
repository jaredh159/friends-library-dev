import React from 'react';
import cx from 'classnames';
import type { HeroIcon } from '@/lib/types';
import Button from './Button';
import { LANG } from '@/lib/env';

interface Props {
  className?: string;
  buttons: {
    text: string;
    icon?: HeroIcon;
    onClick?: () => any;
  }[];
}
const MultiPill: React.FC<Props> = ({ buttons, className }) => (
  <div
    className={cx(
      className,
      `[&>button+button]:ml-[-3.15rem] md:flex MultiPill`,
      LANG === `es` && `max-md:[&>button]:!w-[300px]`,
    )}
  >
    {buttons.map((button, idx) => (
      <Button
        key={button.text}
        {...(button.onClick ? { onClick: button.onClick } : {})}
        width={LANG === `en` ? 280 : idx === 1 ? 320 : 260}
        bg={null}
        className={cx(
          // purgeCSS: bg-flmaroon-600 bg-flmaroon-500 bg-flmaroon-400
          // purgeCSS: bg-flgold-600 bg-flgold-500 bg-flgold-400
          `bg-fl${LANG === `en` ? `maroon` : `gold`}-${[600, 500, 400][idx]}`,
          // purgeCSS: z-30 z-20 z-10
          `z-${[30, 20, 10][idx]}`,
          {
            'mb-2': idx < buttons.length - 1,
            'md:pl-[70px]': idx > 0,
            'md:pl-16': idx === 0,
          },
          `w-full relative after:opacity-0 after:inset-0 after:bg-gray-200 after:rounded-full after:block after:absolute after:transition-opacity after:duration-200 after:ease-in-out after:hover:opacity-[0.085]`,
          `flex items-center`,
        )}
      >
        {button.icon && <button.icon className="h-6 pr-3" />}
        <span>{button.text}</span>
      </Button>
    ))}
  </div>
);

export default MultiPill;
