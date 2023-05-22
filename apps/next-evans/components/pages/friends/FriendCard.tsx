import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import CircleSilhouette from './CircleSilhouette';
import Dual from '@/components/core/Dual';
import Button from '@/components/core/Button';
import Stack from '@/components/core/Stack';
import { HeroIcon } from '@/lib/types';
import { BookOpenIcon, CalendarIcon, FlagIcon } from '@heroicons/react/24/outline';

interface Props {
  className?: string;
  gender: 'male' | 'female';
  name: string;
  born?: number;
  died?: number;
  region: string;
  numBooks: number;
  url: string;
  featured?: boolean;
  color: string;
}

const FriendCard: React.FC<Props> = ({
  className,
  gender,
  born,
  died,
  numBooks,
  region,
  color,
  name,
  url,
  featured = false,
}) => {
  const textColorClass = `text-${featured ? `white` : color}`;
  const buttonBgColor = color.replace(/^bg-fl/, ``) as any;
  return (
    <Stack
      space="8"
      className={cx(
        className,
        textColorClass,
        `flex flex-col items-center [&>*]:translate-y-[31px]`,
        featured
          ? `md:flex-row md:justify-center md:pt-12 md:pb-6 md:[&>*]:transform-none`
          : `min-w-[100%] [&>*]:translate-y-[36px] sm:min-w-[330px]`,
        color,
      )}
    >
      <div
        key="img"
        className={cx(featured && `md:order-2 md:flex`, `flex-col items-center`)}
      >
        <CircleSilhouette gender={gender} fgColor="white" bgColor={color} />
        <Button
          to={url}
          width={220}
          className={cx(`box-content hidden md:mt-6`, {
            'border-2 border-white md:block': featured,
          })}
          bg={buttonBgColor}
        >
          {t`Learn More`}
        </Button>
      </div>
      <div
        key="meta"
        className={cx(
          featured && `md:mr-16 md:self-stretch md:flex md:flex-col md:justify-center`,
        )}
      >
        <h3
          className={cx(
            `sans-wide text-2xl -mt-2 text-center mb-6 after:block after:h-[3px] max-w-[180px] mt-[15px] ml-auto mr-auto`,
            featured && `md:mb-10`,
          )}
        >
          {name}
        </h3>
        {/* purgeCSS: mb-4 */}
        <Stack space="4" el="ul" className={cx(`body-text pb-2`, textColorClass)}>
          <Item key="cal" Icon={CalendarIcon}>
            {lifespan(born, died)}
          </Item>
          <Item key="flag" Icon={FlagIcon}>
            {region}
          </Item>
          <Item key="logo" Icon={BookOpenIcon}>
            <Dual.Frag>
              <>
                {numBooks} book{numBooks > 1 ? `s` : ``} available
              </>
              <>
                {numBooks} libro{numBooks > 1 ? `s` : ``} disponible
                {numBooks > 1 ? `s` : ``}
              </>
            </Dual.Frag>
          </Item>
        </Stack>
      </div>
      {/* purgeCSS: hover:bg-flblue-800 hover:bg-flgreen-800 hover:bg-flmaroon-800 */}
      <Button
        key="button"
        to={url}
        width={220}
        className={cx(`box-content`, {
          'border-4 border-white md:hidden': featured,
        })}
        bg={buttonBgColor}
      >
        {t`Learn More`}
      </Button>
    </Stack>
  );
};

export default FriendCard;

const Item: React.FC<{
  children: React.ReactNode;
  Icon: HeroIcon;
  className?: string;
}> = ({ Icon, children, className }) => (
  <li className={cx(className, `flex items-center`)}>
    <Icon className="mr-4" height={22} /> {children}
  </li>
);

function lifespan(born?: number, died?: number): string {
  if (!born && !died) return `Unknown`;
  if (!born) return `d. ${died}`;
  if (!died) return `b. ${died}`;
  return [born, died].join(` — `);
}
