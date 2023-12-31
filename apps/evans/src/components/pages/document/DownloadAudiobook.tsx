import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import type { AudioQuality } from '@friends-library/types';
import Dual from '../../Dual';
import Stack from '../../layout/Stack';
import Link from '../../Link';
import QualitySwitch from './QualitySwitch';

interface Props {
  className?: string;
  complete: boolean;
  m4bFilesizeLq: string;
  m4bFilesizeHq: string;
  mp3ZipFilesizeLq: string;
  mp3ZipFilesizeHq: string;
  m4bUrlLq: string;
  m4bUrlHq: string;
  mp3ZipUrlLq: string;
  mp3ZipUrlHq: string;
  podcastUrlLq: string;
  podcastUrlHq: string;
  quality: AudioQuality;
  setQuality: (quality: AudioQuality) => any;
}

const DownloadLinks: React.FC<Props> = (props) => {
  let links = {
    mp3Zip: props.mp3ZipUrlHq,
    zipSize: props.mp3ZipFilesizeHq,
    m4b: props.m4bUrlHq,
    m4bSize: props.m4bFilesizeHq,
    podcast: props.podcastUrlHq,
  };
  if (props.quality === `LQ`) {
    links = {
      mp3Zip: props.mp3ZipUrlLq,
      zipSize: props.mp3ZipFilesizeLq,
      m4b: props.m4bUrlLq,
      m4bSize: props.m4bFilesizeLq,
      podcast: props.podcastUrlLq,
    };
  }
  return (
    <div id="audiobook" className={cx(props.className, `bg-white font-sans p-8`)}>
      <h3 className="text-2xl text-center mb-6">{t`Download Audiobook`}</h3>
      {!props.complete && (
        <Dual.P className="text-center sm:pl-10 max-w-sm mx-auto -mt-2 italic font-serif mb-6 text-flblue">
          <>
            <sup>*</sup> The audio for this book is incomplete. The remaining chapters
            will be added soon.
          </>
          <>
            <sup>*</sup> El audio de este libro está incompleto. Los capítulos que faltan
            serán añadidios pronto.
          </>
        </Dual.P>
      )}
      <div className="tracking-widest antialiased flex flex-col items-center">
        <dl className="text-flgray-900 inline-block">
          <dt className="uppercase text-md mb-1">
            <Link to="/app" className="hover:underline">
              <Dual.Span className="sm:hidden">
                <>Get the App</>
                <>Obtén la aplicación</>
              </Dual.Span>
              <Dual.Span className="hidden sm:inline">
                <>Download in the App</>
                <>Descarga en la aplicación</>
              </Dual.Span>
            </Link>
            <Link
              to="/app"
              className="text-xs normal-case bg-flprimary text-white rounded-full -mt-1 ml-4 px-6 py-1"
            >
              {t`Recommended`}
            </Link>
          </dt>
          <dd className="text-flgray-500 text-xs mb-4 pb-1">
            <Dual.Frag>
              <>
                (Listen <span className="hidden sm:inline">on your phone</span> with our
                iOS or Android app)
              </>
              <>
                <span className="sm:hidden">
                  Escucha con nuestra aplicación iOS o Android
                </span>
                <span className="hidden sm:inline">
                  Escucha en tu teléfono con la aplicación iOS o Android
                </span>
              </>
            </Dual.Frag>
          </dd>
          <dt className="uppercase text-md mb-1">
            <a href={links.podcast} className="hover:underline">
              <span className="hidden sm:inline">{t`Download as`} </span>Podcast
            </a>
          </dt>
          <dd className="text-flgray-500 text-xs mb-4 pb-1">
            (Apple Podcasts, Stitcher,{` `}
            <span className="hidden sm:inline">Overcast, </span>
            etc.)
          </dd>
          <dt className="uppercase text-md mb-1">
            <a href={links.mp3Zip} className="hover:underline">
              {t`Download mp3 Files as Zip`} -{` `}
              <span className="text-flprimary">({links.zipSize})</span>
            </a>
          </dt>
          <dd className="text-flgray-500 text-xs mb-4 pb-1">
            <Dual.Frag>
              <>(use in iTunes, or any music app)</>
              <>(Para usar en iTunes, o en cualquier aplicación de música)</>
            </Dual.Frag>
          </dd>
          <dt className="uppercase text-md mb-1">
            <a href={links.m4b} className="hover:underline">
              <Dual.Frag>
                <>
                  Download .M4B Audiobook <span className="hidden sm:inline">File</span> -
                  {` `}
                </>
                <>
                  Descargar Audiolibro{` `}
                  <span className="hidden sm:inline">en archivo</span> M4b -{` `}
                </>
              </Dual.Frag>
              <span className="text-flprimary">({links.m4bSize})</span>
            </a>
          </dt>
          <dd className="text-flgray-500 text-xs mb-4 pb-1">
            <Dual.Frag>
              <>
                (Audiobook format for{` `}
                <span className="hidden sm:inline">Apple Books, </span>
                iTunes, etc.)
              </>
              <>
                (Formato de Audiolibro para{` `}
                <span className="hidden sm:inline">Aplicación de Libros, </span>
                iTunes, etc.)
              </>
            </Dual.Frag>
          </dd>
        </dl>
      </div>
      {/* purgeCSS: mb-6 */}
      <Stack space="6" className="flex flex-col items-center mt-6 mb-4">
        <QualitySwitch key="switch" quality={props.quality} onChange={props.setQuality} />
        <p key="text" className="text-flgray-500 text-base antialiased tracking-wider">
          (
          {props.quality === `HQ`
            ? t`Higher quality, larger file size`
            : t`Lower quality, faster download`}
          )
        </p>
        <Link
          key="help"
          className="text-flprimary text-sm tracking-wider"
          to={t`/audio-help`}
        >
          <span className="fl-underline">{t`Need Help?`}</span>
          {` `}
          <i className="fa fa-life-ring opacity-75 pl-1" />
        </Link>
      </Stack>
    </div>
  );
};

export default DownloadLinks;
