import React from 'react';
import { t } from '@friends-library/locale';
import type { FluidBgImageObject } from '../../../types';
import Dual from '../../Dual';
import { bgLayer } from '../../lib/color';
import BackgroundImage from '../../BackgroundImage';
import Link from '../../Link';

interface Props {
  bgImg: FluidBgImageObject;
}

const GettingStartedLinkBlock: React.FC<Props> = ({ bgImg }) => (
  <BackgroundImage
    fluid={[bgLayer(`flblue`, 0.8), bgImg]}
    fadeIn={false}
    id="GettingStartedLinkBlock"
    className="p-16 bg-cover sm:p-20 md:p-24"
  >
    <Dual.H3 className="text-white text-center font-sans leading-loose tracking-wider text-lg antialiased">
      <>
        Looking for just a few hand-picked recommendations? Head on over to our{` `}
        <Link className="fl-underline" to={t`/getting-started`}>
          getting started
        </Link>
        {` `}
        page!
      </>
      <>
        ¿Estás buscando solo algunas recomendaciones escogidas? Haz clic aquí para ver
        {` `}
        <Link className="fl-underline" to={t`/getting-started`}>
          cómo comenzar
        </Link>
        .
      </>
    </Dual.H3>
  </BackgroundImage>
);

export default GettingStartedLinkBlock;
