import React from 'react';
import css from 'x-syntax';
import { CoverProps, PrintSize } from '@friends-library/types';
import {
  Back,
  Spine,
  css as coverCss,
  wrapClasses,
} from '@friends-library/cover-component';

export const Style: React.FC<{
  scaler?: number;
  scope?: string;
  author?: string;
  showGuides?: boolean;
  size?: PrintSize;
  type: '3d' | 'front' | 'back' | 'spine' | 'pdf';
}> = ({ type, scaler, scope, author, showGuides, size }) => {
  const useProps = {
    ...props,
    size: size || props.size,
    author: author || props.author,
    showGuides: showGuides || props.showGuides,
  };
  const args: [number?, string?] = [scaler, scope];
  return (
    <>
      <CommonStyles />
      <style>
        {coverCss.common(...args)[1]}
        {[`front`, `3d`, `pdf`].includes(type) ? coverCss.front(...args)[1] : ``}
        {[`back`, `3d`, `pdf`].includes(type) ? coverCss.back(...args)[1] : ``}
        {[`spine`, `3d`, `pdf`].includes(type) ? coverCss.spine(...args)[1] : ``}
        {useProps.showGuides ? coverCss.guides(...args)[1] : ``}
        {type === `3d` ? coverCss.threeD(...args)[1] : ``}
        {type === `pdf` ? coverCss.pdf(useProps, ...args)[1] : ``}
      </style>
    </>
  );
};

export const Wrapped: React.FC<
  Partial<CoverProps> & {
    type: 'back' | 'spine';
    style?: Record<string, string | number>;
  }
> = (wProps) => {
  const useProps = p(wProps);
  return (
    <div
      className={wrapClasses(useProps, `type--${wProps.type}`)}
      style={wProps.style ? wProps.style : {}}
    >
      {wProps.type === `back` && <Back {...useProps} />}
      {wProps.type === `spine` && <Spine {...useProps} />}
    </div>
  );
};

export const CommonStyles: React.FC = () => (
  <style>
    {coverCss.allStatic(true)}
    {css`
      .all-sizes {
        width: 17in;
      }
      .all-sizes .Cover {
        vertical-align: top;
      }
      .Cover + .Cover,
      style + .Cover {
        margin-left: 20px;
      }
      .Cover-storybook-bg {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: #eaeaea;
      }
    `}
  </style>
);

export function p(overrides: Partial<CoverProps>): CoverProps {
  return { ...props, ...overrides };
}

export const props: CoverProps & { htmlShortTitle: string } = {
  lang: `en`,
  size: `s`,
  pages: 222,
  isCompilation: false,
  blurb: `Samuel Rundell (1762 - 1848) was a wool-dealer who lived in Liskeard, a small town in southwest England. When young he befriended that worthy elder and "mother in Israel" Catherine Payton (Phillips), whose wisdom and piety no doubt made lasting impressions upon him. As a minister and author, Rundell was particularly concerned to press the necessity of a real and living experience of inward purification by an unreserved obedience to the light or Spirit of Christ working in the heart. Having witnessed in his own soul, he to.`,
  showGuides: false,
  edition: `updated`,
  title: `The Work of Vital Religion in the Soul`,
  htmlShortTitle: `The Work of Vital Religion in the Soul`,
  isbn: `978-1-64476-000-0`,
  author: `Samuel Rundell`,
  customCss: ``,
  customHtml: ``,
};

export const parameters = {
  backgrounds: { default: `gray`, values: [{ name: `gray`, value: `#eaeaea` }] },
};
