import React from 'react';
import cx from 'classnames';
import { CoverProps } from '@friends-library/types';
import { Front } from '@friends-library/cover-component';
import coverMap from './cover-props';
import CoverCss from './CoverCss';
import './BooksBg.css';

const BooksBg: React.FC<{ right?: boolean }> = ({ right }) => {
  const turford = get(`en/hugh-turford/walk-in-the-spirit/updated`);
  const griffeth = get(`en/john-griffith/ancient-path/updated`);
  const esIP = get(`es/isaac-penington/escritos-volumen-1/updated`);
  const blue = get(`en/william-penn/no-cross-no-crown/updated`);
  griffeth.edition = `original`;
  blue.edition = `modernized`;
  return (
    <>
      <CoverCss scaler={SCALER} scope={SCOPE} />
      <div
        className={cx(`BooksBg bg-black absolute grid grid-cols-7`, right && `right`)}
        style={{
          width: poster.width * (1 + poster.offset),
          height: poster.height * (1 + poster.offset),
          top: poster.height * (poster.offset / 2) * -1 + 88,
          left: poster.width * (poster.offset / 2) * -1,
        }}
      >
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...esIP} scope={SCOPE} scaler={SCALER} />
        <Front {...griffeth} scope={SCOPE} scaler={SCALER} />
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...blue} scope={SCOPE} scaler={SCALER} />
        <Front {...esIP} scope={SCOPE} scaler={SCALER} />
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...esIP} scope={SCOPE} scaler={SCALER} />
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...esIP} scope={SCOPE} scaler={SCALER} />
        <Front {...blue} scope={SCOPE} scaler={SCALER} />
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...griffeth} scope={SCOPE} scaler={SCALER} />
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...esIP} scope={SCOPE} scaler={SCALER} />
        <Front {...blue} scope={SCOPE} scaler={SCALER} />
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...griffeth} scope={SCOPE} scaler={SCALER} />
        <Front {...turford} scope={SCOPE} scaler={SCALER} />
        <Front {...esIP} scope={SCOPE} scaler={SCALER} />
        <Front {...blue} scope={SCOPE} scaler={SCALER} />
      </div>
    </>
  );
};

export default BooksBg;

const SCALER = 0.75;
const SCOPE = `books-bg-component`;
const poster = {
  width: 1920,
  height: 1080,
  offset: 0.2,
};

function get(editionPath: string): CoverProps {
  const props = coverMap[editionPath];
  if (!props) throw new Error(`No props for ${editionPath}`);
  const copy = { ...props };
  copy.size = `s`;
  return copy;
}
