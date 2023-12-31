import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import type { AddressWithEmail } from '../../types';
import Dual from '../Dual';
import Button from '../Button';
import ShippingAddress from '../ShippingAddress';
import { useAddress } from '../lib/hooks';
import Link from '../Link';
import Header from './Header';
import Progress from './Progress';
import MessageThrobber from './MessageThrobber';
import Back from './Back';
import NoProfit from './NoProfit';
import ErrorMsg from './ErrorMsg';

const Delivery: React.FC<{
  onSubmit: (address: AddressWithEmail) => void;
  onBack: () => void;
  stored?: Partial<AddressWithEmail>;
  throbbing?: boolean;
  error?: boolean;
}> = ({ onSubmit, onBack, stored = {}, error, throbbing }) => {
  const [addressProps, addressWithEmail, addressValid] = useAddress(stored);

  return (
    <div className={cx(throbbing && `pointer-events-none`)}>
      <Header>{t`Delivery`}</Header>
      {!error && <NoProfit className="hidden md:block" />}
      <Progress step="Delivery" />
      {error && <ShippingError />}
      <form
        className="mt-8 relative"
        onSubmit={(e) => {
          e.preventDefault();
          if (addressValid && !throbbing) {
            onSubmit(addressWithEmail);
          }
        }}
      >
        {throbbing && <MessageThrobber />}
        <div
          className={cx(
            `InputWrap md:flex flex-wrap justify-between`,
            throbbing && `blur`,
          )}
        >
          <ShippingAddress {...addressProps} autoFocusFirst={!throbbing} />
        </div>
        <Back className={cx(throbbing && `blur`)} onClick={onBack}>
          {t`Back to Order`}
        </Back>
        <Button shadow className="mx-auto" disabled={!addressValid || throbbing}>
          {t`Payment`} &nbsp;&rsaquo;
        </Button>
      </form>
    </div>
  );
};

export default Delivery;

const ShippingError: React.FC = () => (
  <ErrorMsg>
    <Dual.Frag>
      <>
        Sorry, we’re not able to ship to that address. Sometimes using an{` `}
        <i>abbreviation</i> for the state/province/region makes a difference. If not,
        please double-check for any errors, or try an <i>alternate address</i> where you
        could receive a shipment. Still no luck? We might not be able to ship directly to
        your location, but you can{` `}
        <Link to={t`/contact`} className="underline">
          contact us
        </Link>
        {` `}
        to arrange an alternate shipment.
      </>
      <>
        Lo sentimos, no podemos hacer envíos a esa dirección. Por favor, comprueba si hay
        algún <em>error,</em> o intenta una <em>dirección alternativa</em> donde puedas
        recibir el envío. ¿Todavía no lo has logrado? Es posible que no podamos enviar
        directamente a esa ubicación, pero{` `}
        <Link to={t`/contact`} className="underline">
          contáctanos
        </Link>
        {` `}
        para acordar un envío alternativo.
      </>
    </Dual.Frag>
  </ErrorMsg>
);
