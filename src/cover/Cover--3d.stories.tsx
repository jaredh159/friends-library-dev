import React from 'react';
import { Meta } from '@storybook/react';
import { ThreeD } from '@friends-library/cover-component';
import { Style, parameters, props } from './cover-helpers';

export default {
  title: `Cover/Variants/3D`,
  component: ThreeD,
  parameters,
} as Meta;

export const AngleBack = () => (
  <>
    <ThreeD {...props} perspective="angle-back" />
    <Style type="3d" />
  </>
);

export const AngleFront = () => (
  <>
    <ThreeD {...props} perspective="angle-front" />
    <Style type="3d" />
  </>
);
