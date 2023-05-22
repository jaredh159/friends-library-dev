import React from 'react';
import Image from 'next/image';
import cx from 'classnames';

interface Props {
  src: string;
  fit: 'cover' | 'contain' | 'fill' | 'none' | 'scale-down';
  position:
    | 'top'
    | 'bottom'
    | 'center'
    | 'left'
    | 'right'
    | 'top-left'
    | 'top-right'
    | 'bottom-left'
    | 'bottom-right';
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

const positionMap = {
  top: `object-top`,
  bottom: `object-bottom`,
  center: `object-center`,
  left: `object-left`,
  right: `object-right`,
  'top-left': `object-left-top`,
  'top-right': `object-right-top`,
  'bottom-left': `object-left-bottom`,
  'bottom-right': `object-right-bottom`,
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
      className={cx(fitMap[fit], positionMap[position], `absolute top-0 left-0`)}
      style={{ width: `100%`, height: `100%` }}
    />
    <div className="relative Content">{children}</div>
  </div>
);

export default BackgroundImage;
