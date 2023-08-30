import React from 'react';
import cx from 'classnames';
import { LANG } from '@/lib/env';

const SpanishFreeBooksNote: React.FC<{ className?: string }> = ({ className }) => {
  if (LANG === `en`) return null;
  return (
    <p className={cx(className, `text-center italic`)}>
      Si deseas un ejemplar impreso pero, por razones económicas o de otro tipo, no puedes
      hacer un pedido en línea,{` `}
      <button
        onClick={() => {}} // <- TODO
        className="italic subtle-link hover:border-solid"
      >
        haz clic aquí
      </button>
      {` `}
      para solicitarlo gratuitamente.
    </p>
  );
};

export default SpanishFreeBooksNote;
