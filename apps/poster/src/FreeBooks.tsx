import React from 'react';
import { Lang } from '@friends-library/types';
import BooksBg from './BooksBg';

interface Props {
  lang: Lang;
}

const FreeBooks: React.FC<Props> = ({ lang }) => {
  return (
    <div className="youtube-poster">
      <BooksBg />
      <div
        className="text-white absolute inset-0 z-10 p-64 px-80 space-y-16 flex flex-col items-center justify-center"
        style={{ textShadow: `2px 2px black` }}
      >
        <h1 className="text-7xl tracking-wider">
          {lang === `en` ? `Download this book for free` : `Descarga este libro gratis`}
        </h1>
        <p className="text-3xl antialiased text-center opacity-90 leading-loose">
          {lang === `en` ? (
            <>
              This entire book (plus 130+ more) can be downloaded from our website for
              free as a PDF or E-Book. The audiobook is also available to be downloaded as
              MP3s or in our free iOS and Android apps. See the links in the description
              below.
            </>
          ) : (
            <>
              Este libro completo (y otros 30+ libros más) puede descargarse en PDF o
              E-Book gratuitamente desde nuestro sitio web. Además de esto, el audiolibro
              puede descargarse en MP3 o en nuestra Aplicación gratuita (disponible en iOS
              y Android). El enlace se encuentra más abajo en la descripción.
            </>
          )}
        </p>
        <h2 className="text-flgold tracking-wider font-bold text-6xl">
          {lang === `en` ? `www.friendslibrary.com` : `www.bibliotecadelosamigos.org`}
        </h2>
      </div>
    </div>
  );
};

export default FreeBooks;
