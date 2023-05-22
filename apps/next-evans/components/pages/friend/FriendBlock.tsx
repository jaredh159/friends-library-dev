import React from 'react';
import cx from 'classnames';
import { Male, Female } from './Silhouettes';

interface Props {
  name: string;
  gender: 'male' | 'female' | 'mixed';
  blurb: string;
}

const FriendBlock: React.FC<Props> = ({ name, gender, blurb }) => (
  <div className="flex flex-col md:flex-row items-center md:items-start justify-center p-8 sm:p-12 md:p-20">
    <div className="flex flex-col items-center mb-8 md:mb-0">
      {gender === `female` && <Female />}
      {gender === `male` && <Male />}
      <h1 className="font-sans md:hidden font-bold text-xl mt-4 tracking-wider">
        {name}
      </h1>
    </div>
    <div className={cx(gender !== `mixed` && `md:ml-12`, `max-w-4xl`)}>
      <h1 className="hidden md:block font-sans font-bold antialiased text-flprimary text-3xl mb-4 tracking-wider">
        {name}
      </h1>
      <p className="body-text">{blurb}</p>
    </div>
  </div>
);

export default FriendBlock;
