import React from 'react';
import css from 'x-syntax';
import { Meta } from '@storybook/react';
import { Front } from '@friends-library/cover-component';
import { Style, parameters, p, props } from './cover-helpers';
import books from './books';

export default {
  title: `Cover/Variants/Front`,
  component: Front,
  parameters,
} as Meta;

export const Basic = () => (
  <>
    <Front {...props} />
    <Style type="front" />
  </>
);

export const ThreePrintSizes = () => (
  <div className="all-sizes">
    <Front {...p({ scope: `s`, size: `s` })} />
    <Front {...p({ scope: `m`, size: `m` })} />
    <Front {...p({ scope: `xl`, size: `xl` })} />
    <Style type="front" size="s" scope="s" />
    <Style type="front" size="m" scope="m" />
    <Style type="front" size="xl" scope="xl" />
  </div>
);

export const Scaled = () => {
  const sizes: [string, number][] = [
    [`full`, 1],
    [`half`, 0.5],
    [`third`, 0.333333],
    [`quarter`, 0.225],
    [`fifth`, 0.14],
    [`sixth`, 0.1],
  ];
  return (
    <div style={{ display: `flex`, alignItems: `center` }}>
      {sizes.map(([scope, scaler]) => (
        <>
          <Front {...p({ scope, scaler })} />
          <Style type="front" scope={scope} scaler={scaler} />
        </>
      ))}
    </div>
  );
};

export const TitleSquares = () => {
  return (
    <div className="grid">
      <style>{css`
        .grid {
          display: flex;
          flex-wrap: wrap;
          margin-right: -1.25em;
        }
        .grid .square {
          height: 4.42in;
          overflow: hidden;
          border: 1.25em solid transparent;
          border-left-width: 0;
          border-top-width: 0;
        }
        .grid .square .Cover {
          top: -1.31in;
        }
        .grid .square .author {
          opacity: 0;
        }
      `}</style>
      {books.map(([scope, title, author]) => (
        <div className="square">
          <Front
            {...p({
              scope,
              author,
              title,
              size: `s`,
              isCompilation: author.startsWith(`Compila`),
            })}
          />
          <Style type="front" scope={scope} author={author} size="s" />
        </div>
      ))}
    </div>
  );
};
