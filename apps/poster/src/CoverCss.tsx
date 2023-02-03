import React from 'react';
import { CoverWebStylesAllStatic, css } from '@friends-library/cover-component';

interface Props {
  scaler: number;
  scope: string;
}

const CoverCss: React.FC<Props> = ({ scaler, scope }) => (
  <>
    <CoverWebStylesAllStatic />
    <style>
      {[
        css.common(scaler, scope)[1],
        css.front(scaler, scope)[1],
        css.back(scaler, scope)[1],
        css.spine(scaler, scope)[1],
        css.threeD(scaler, scope)[1],
      ].join(`\n`)}
    </style>
  </>
);

export default CoverCss;
