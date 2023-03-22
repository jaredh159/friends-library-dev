import React from 'react';
import { PrintPdf } from '@friends-library/cover-component';
import type { Meta } from '@storybook/react';
import { Style, parameters, props, p } from '../cover-helpers';

export default {
  title: 'Cover/Variants/Pdf', // eslint-disable-line
  component: PrintPdf,
  parameters,
} as Meta;

export const WithBleed = () => (
  <>
    <PrintPdf {...props} />
    <Style type="pdf" />
  </>
);

export const NoBleed = () => (
  <>
    <PrintPdf {...props} bleed={false} />
    <Style type="pdf" showGuides={true} />
  </>
);

export const WithGuides = () => (
  <>
    <PrintPdf {...p({ showGuides: true })} />
    <Style type="pdf" showGuides={true} />
  </>
);
