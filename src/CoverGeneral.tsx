import React from 'react';
import { t, setLocale } from '@friends-library/locale';
import LogoFriends from 'evans/components/LogoFriends';
import LogoAmigos from 'evans/components/LogoAmigos';
import { ThreeD } from '@friends-library/cover-component';
import coverPropsMap from './cover-props';
import CoverCss from './CoverCss';
import { htmlTitle } from './helpers';

const CoverGeneral: React.FC<{ editionPath: string }> = ({ editionPath }) => {
  const coverProps = coverPropsMap[editionPath];
  if (!coverProps) return null;
  const { lang, author, title, size } = coverProps;
  setLocale(lang);
  const Logo = lang === `en` ? LogoFriends : LogoAmigos;
  let scaler = 1.62;
  if (size === `m`) {
    scaler = 1.32;
  } else if (size === `xl`) {
    scaler = 1.23;
  }
  return (
    <div className="youtube-poster flex bg-flgray-400">
      <CoverCss scaler={scaler} scope={SCOPE} />
      <div className="ml-6">
        <ThreeD shadow {...coverProps} scaler={scaler} scope={SCOPE} />
      </div>
      <div className="flex-grow p-32 pl-0 flex flex-col space-y-20 items-center justify-center text-center">
        <h1
          className={`serif text-8xl text-fl${lang === `en` ? `maroon` : `gold`}`}
          style={{ lineHeight: `150%` }}
          dangerouslySetInnerHTML={{ __html: htmlTitle(title, author) }}
        />
        {!author.startsWith(`Compila`) && (
          <h2 className="serif text-5xl text-gray-600 antialiased italic">
            {t`by`} {author}
          </h2>
        )}
        <div className={`w-${lang === `en` ? `80` : `96`} pt-6`}>
          <Logo iconColor="white" friendsColor="white" libraryColor="white" />
        </div>
        <p className="sans text-2xl opacity-50 antialiased">
          {lang === `en` ? `www.friendslibrary.com` : `www.bibliotecadelosamigos.org`}
        </p>
      </div>
    </div>
  );
};

export default CoverGeneral;

const SCOPE = `cover-general-component`;
