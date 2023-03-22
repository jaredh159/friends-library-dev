import React from 'react';
import { Spine } from '@friends-library/cover-component';
import type { Meta } from '@storybook/react';
import type { PrintSize } from '@friends-library/types';
import { Wrapped, Style, parameters, p } from '../cover-helpers';

export default {
  title: 'Cover/Variants/Spine', // eslint-disable-line
  component: Spine,
  parameters,
} as Meta;

export const Basic = () => (
  <>
    <Wrapped type="spine" />
    <Style type="spine" />
  </>
);

export const ThreePrintSizes = () => {
  const sizes: PrintSize[] = [`s`, `m`, `xl`];
  return (
    <div>
      {sizes.map((size) => {
        return (
          <>
            <Wrapped
              type="spine"
              {...p({ size, scope: size })}
              style={{ marginRight: 75 }}
            />
            <Style type="spine" scope={size} size={size} />
          </>
        );
      })}
    </div>
  );
};
