import React from 'react';
import GatsbyLink from 'gatsby-link';

interface Props {
  to: string;
  children?: React.ReactNode;
  className?: string;
  dangerouslySetInnerHTML?: { __html: string };
  style?: React.CSSProperties;
}

const Link: React.FC<Props> = ({ children, ...props }) => (
  // @ts-ignore
  <GatsbyLink {...props}>{children}</GatsbyLink>
);

export default Link;
