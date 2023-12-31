import React from 'react';
import cx from 'classnames';
import './WaveBottomBlock.css';

interface Props {
  color: 'blue' | 'maroon' | 'green' | 'gold';
  className?: string;
  id?: string;
  children: React.ReactNode;
}

const WaveBottomBlock: React.FC<Props> = ({ id, color, children, className }) => (
  <section id={id} className={cx(className, `WaveBottomBlock WaveBottomBlock--${color}`)}>
    {children}
  </section>
);

export default WaveBottomBlock;
