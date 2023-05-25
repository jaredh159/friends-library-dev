import React from 'react';
import Image from 'next/image';
import cx from 'classnames';
import type { StaticImageData } from 'next/image';

interface Props {
  src: string | StaticImageData;
  fit: 'cover' | 'contain' | 'fill' | 'none' | 'scale-down';
  position: string;
  children?: React.ReactNode;
  className?: string;
}

const fitMap = {
  cover: `object-cover`,
  contain: `object-contain`,
  fill: `object-fill`,
  none: `object-none`,
  'scale-down': `object-scale-down`,
};

const BackgroundImage: React.FC<Props> = ({
  src,
  className,
  children,
  fit,
  position,
}) => (
  <div className={cx(`relative`, className)}>
    <Image
      src={src}
      width={1000}
      height={1000}
      alt=""
      role="presentation"
      className={cx(fitMap[fit], position, `absolute top-0 left-0`)}
      style={{ width: `100%`, height: `100%` }}
    />
    <div className="relative Content">{children}</div>
  </div>
);

export default BackgroundImage;