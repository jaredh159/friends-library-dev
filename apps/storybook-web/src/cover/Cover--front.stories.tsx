import React from 'react';
import { Meta } from '@storybook/react';
import { Front } from '@friends-library/cover-component';
import { Style, parameters, p, props } from '../cover-helpers';

export default {
  title: `Cover/Variants/Front`,
  component: Front,
  parameters,
} as Meta;

export const Basic = () => (
  <>
    <Front {...props} />
    <Style type="front" />
  </>
);

export const ThreePrintSizes = () => (
  <div className="all-sizes">
    <Front {...p({ scope: `s`, size: `s` })} />
    <Front {...p({ scope: `m`, size: `m` })} />
    <Front {...p({ scope: `xl`, size: `xl` })} />
    <Style type="front" size="s" scope="s" />
    <Style type="front" size="m" scope="m" />
    <Style type="front" size="xl" scope="xl" />
  </div>
);

export const Scaled = () => {
  const sizes: [string, number][] = [
    [`full`, 1],
    [`half`, 0.5],
    [`third`, 0.333333],
    [`quarter`, 0.225],
    [`fifth`, 0.14],
    [`sixth`, 0.1],
  ];
  return (
    <div style={{ display: `flex`, alignItems: `center` }}>
      {sizes.map(([scope, scaler]) => (
        <>
          <Front {...p({ scope, scaler })} />
          <Style type="front" scope={scope} scaler={scaler} />
        </>
      ))}
    </div>
  );
};
