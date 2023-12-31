import React from 'react';
import { t } from '@friends-library/locale';
import MultiPill from '../../MultiPill';

interface Props {
  price: number;
  hasAudio: boolean;
  addToCart: () => void;
  download: () => any;
  gotoAudio: () => any;
  className?: string;
}

const DocActions: React.FC<Props> = ({
  price,
  addToCart,
  hasAudio,
  download,
  gotoAudio,
  className = ``,
}) => (
  <MultiPill
    className={className}
    buttons={[
      {
        text: t`Download`,
        icon: `cloud`,
        onClick: download,
      },
      {
        text: `${t`Paperback`} $${(price / 100).toFixed(2)}`,
        icon: `book`,
        onClick: addToCart,
      },
      ...(hasAudio
        ? [{ text: t`Audiobook`, icon: `headphones`, onClick: gotoAudio }]
        : []),
    ]}
  />
);

export default DocActions;
