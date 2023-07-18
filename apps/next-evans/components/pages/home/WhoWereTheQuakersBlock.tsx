import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import BackgroundImage from '@/components/core/BackgroundImage';
import Heading from '@/components/core/Heading';
import Dual from '@/components/core/Dual';
import Button from '@/components/core/Button';
import TowerBridgeImg from '@/public/images/london.jpg';
import { LANG } from '@/lib/env';

const WhoWereTheQuakersBlock: React.FC = () => (
  <BackgroundImage src={TowerBridgeImg} fit="cover" position="object-[center_20%]">
    <div
      className={cx(
        `text-white flex flex-col items-center py-12 sm:py-16 px-12  md:px-16 lg:px-20 lg:py-24`,
        LANG === `en`
          ? `[background:linear-gradient(rgba(110,45,70,0.9),rgba(110,45,70,0.9))]`
          : `[background:linear-gradient(rgba(195,142,97,0.9),rgba(195,142,97,0.9))]`,
      )}
    >
      <Heading darkBg>
        <Dual.Frag>
          <>Who were the Quakers?</>
          <>¿Quiénes eran los Cuáqueros?</>
        </Dual.Frag>
      </Heading>
      <Dual.P className="font-serif text-lg sm:text-xl opacity-75 leading-relaxed max-w-6xl">
        <>
          The early Quakers arose in the mid 1600&rsquo;s in England. Dissatisfied with
          lifeless religion, outward forms and ceremonies, their hearts longed to
          experience the true life and power of New Testament Christianity. They came to
          see that the same Jesus Christ who died on the cross for our sins also appears
          by His Spirit in our hearts, and that, when yielded to, His heavenly light and
          grace becomes our salvation as it purifies and truly changes us from within.
        </>
        <>
          Los primeros Cuáqueros surgieron en Inglaterra a mediados de los 1600.
          Insatisfechos con la religión sin vida, formas y ceremonias externas, sus
          corazones anhelaban experimentar la verdadera vida y poder del cristianismo del
          Nuevo Testamento. Llegaron a ver que el mismo Jesucristo que murió en la cruz
          por nuestros pecados también aparece por Su Espíritu en nuestros corazones, y
          que cuando uno se entrega a dicha aparición, Su luz y gracia celestial se
          vuelven nuestra salvación a medida que nos purifica y nos cambia verdaderamente
          desde nuestro interior.
        </>
      </Dual.P>
      <Button to={t`/quakers`} className="mt-12" bg="blue" shadow>
        {t`Find out more`}
      </Button>
    </div>
  </BackgroundImage>
);

export default WhoWereTheQuakersBlock;
