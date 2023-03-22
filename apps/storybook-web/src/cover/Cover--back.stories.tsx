import React from 'react';
import { Back } from '@friends-library/cover-component';
import type { Meta } from '@storybook/react';
import { Wrapped, Style, parameters } from '../cover-helpers';

export default {
  title: 'Cover/Variants/Back', // eslint-disable-line
  component: Back,
  parameters,
} as Meta;

export const Basic = () => (
  <>
    <Wrapped type="back" />
    <Style type="back" />
  </>
);

export const ThreePrintSizes = () => (
  <div className="all-sizes">
    <Wrapped type="back" {...{ scope: `s`, size: `s` }} />
    <Wrapped type="back" {...{ scope: `m`, size: `m` }} />
    <Wrapped type="back" {...{ scope: `xl`, size: `xl` }} />
    <Style type="back" size="s" scope="s" />
    <Style type="back" size="m" scope="m" />
    <Style type="back" size="xl" scope="xl" />
  </div>
);

export const Scaled = () => {
  const sizes: [string, number][] = [
    [`back-full`, 1],
    [`back-half`, 0.5],
    [`back-third`, 0.333333],
    [`back-quarter`, 0.225],
    [`back-fifth`, 0.14],
    [`back-sixth`, 0.1],
  ];
  return (
    <div style={{ display: `flex`, alignItems: `center` }}>
      {sizes.map(([scope, scaler]) => (
        <>
          <Wrapped type="back" {...{ scope, scaler }} />
          <Style type="back" scope={scope} scaler={scaler} />
        </>
      ))}
    </div>
  );
};
