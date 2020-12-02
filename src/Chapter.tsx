import React from 'react';
import cx from 'classnames';
import { Lang } from '@friends-library/types';
import { setLocale } from '@friends-library/locale';
import Album from 'evans/components/Album';
import coverPropsMap from './cover-props';
import partTitlesMap from './part-titles';
import BooksBg from './BooksBg';
import CoverCss from './CoverCss';
import { htmlTitle } from './helpers';
import './Chapter.css';

interface Props {
  lang: Lang;
  editionPath: string;
  partIdx: number;
}

const Chapter: React.FC<Props> = ({ lang, editionPath, partIdx }) => {
  const coverProps = coverPropsMap[editionPath];
  if (!coverProps) throw new Error(`missing cover props for ${editionPath}`);
  const parts = partTitlesMap[editionPath];
  const title = htmlTitle(parts[partIdx], coverProps.author);
  setLocale(lang);
  return (
    <div className="Chapter youtube-poster">
      <CoverCss scaler={1} scope="custom-1" />
      <BooksBg right />
      <div className="youtube-poster z-10 flex items-center justify-center px-36">
        <div
          className="flex-grow max-w-4xl space-y-12 mr-20 text-white text-center"
          style={{ textShadow: `2px 2px black` }}
        >
          <h2 className="text-4xl sans">
            {lang === `en` ? (
              <>
                Part {partIdx + 1} of {parts.length}
              </>
            ) : (
              <>
                Parte {partIdx + 1} de {parts.length}
              </>
            )}
          </h2>
          <h1
            className={cx(
              `text-${
                title.length > 60 ? 6 : title.length < 30 ? 8 : 7
              }xl sans tracking-wide leading-normal`,
            )}
            dangerouslySetInnerHTML={{ __html: title }}
          />
          <h3
            className="text-3xl tracking-wide serif"
            dangerouslySetInnerHTML={{
              __html: htmlTitle(coverProps.title, coverProps.author),
            }}
          />
        </div>
        <Album scaler={1} scope="custom-1" {...coverProps} />
      </div>
    </div>
  );
};

export default Chapter;
