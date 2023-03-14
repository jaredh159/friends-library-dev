import React from 'react';
import { Link as GatsbyLink } from 'gatsby';

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
