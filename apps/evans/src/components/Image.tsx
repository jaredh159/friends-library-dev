import React from 'react';
import GatsbyImage from 'gatsby-image';
import type { FluidImageObject } from '../types';

interface Props {
  fluid: FluidImageObject;
  className?: string;
  alt?: string;
  fadeIn?: boolean;
  durationFadeIn?: number;
}

const Image: React.FC<Props> = ({ fluid, className, alt, fadeIn, durationFadeIn }) => (
  // @ts-ignore
  <GatsbyImage
    fluid={fluid}
    className={className}
    alt={alt}
    fadeIn={fadeIn}
    durationFadeIn={durationFadeIn}
  />
);

export default Image;
