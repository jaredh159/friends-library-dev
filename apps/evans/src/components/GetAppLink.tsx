import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import { LANG } from './env';
import Link from './Link';

interface Props {
  iconClassName?: string;
}

const GetAppLink: React.FC<Props> = ({ iconClassName }) => (
  <Link className="GetAppLink relative" to={t`/app`}>
    {LANG === `en` ? `Get the app` : `Aplicación`}
    <i
      className={cx(`fa fa-mobile ml-2 text-3xl opacity-75 antialiased`, iconClassName)}
    />
  </Link>
);

export default GetAppLink;
