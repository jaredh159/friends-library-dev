import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import Link from 'next/link';
import { LANG } from '@/lib/env';

interface Props {
  className?: string;
}

const GetAppLink: React.FC<Props> = ({ className }) => (
  <Link className={cx(`relative flex items-center`, className)} href={t`/app`}>
    {LANG === `en` ? `Get the app` : `Aplicación`}
    <i aria-hidden className="fa fa-mobile text-xl ml-1.5 opacity-70" />
  </Link>
);

export default GetAppLink;
