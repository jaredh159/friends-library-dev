import React from 'react';
import GatsbyBackgroundImage from 'gatsby-background-image-preact';
import type { FluidBgImageObject } from '../types';

interface Props {
  fluid: FluidBgImageObject | Array<string | FluidBgImageObject>;
  rootMargin?: string;
  fadeIn?: boolean;
  id?: string;
  className?: string;
  as?: string;
  style?: React.CSSProperties;
  children?: React.ReactNode;
}

const BackgroundImage: React.FC<Props> = (props: Props) => (
  // @ts-ignore
  <GatsbyBackgroundImage {...props} />
);

export default BackgroundImage;
