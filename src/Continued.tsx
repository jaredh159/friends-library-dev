import React from 'react';
import { Lang } from '@friends-library/types';

interface Props {
  lang: Lang;
}

const Continued: React.FC<Props> = ({ lang }) => {
  return (
    <div
      className="Continued youtube-poster bg-flmaroon"
      style={{
        backgroundImage: `radial-gradient(rgba(0, 0, 0, 0.15), rgba(0, 0, 0, 0.675) 70%, rgba(0, 0, 0, 0.9) 95%`,
      }}
    >
      <div
        className="text-white absolute inset-0 z-10 py-64 px-80 space-y-16 flex flex-col items-center justify-center"
        style={{ textShadow: `2px 2px black` }}
      >
        <p className="text-5xl antialiased text-center opacity-90 leading-loose">
          {lang === `en` ? (
            <>
              This audiobook has been broken into multiple parts.
              <br />
              To continue listening, click the link to the next part in the description
              below.
            </>
          ) : (
            <>
              Este audiolibro ha sido divido en varias partes.
              <br />
              Para seguir escuchándolo, haz clic en el enlace de la siguiente parte, el
              cual encontrarás más abajo en la descripción.
            </>
          )}
        </p>
      </div>
    </div>
  );
};

export default Continued;
