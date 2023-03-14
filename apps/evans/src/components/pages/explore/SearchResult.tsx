import React from 'react';
import { Front } from '@friends-library/cover-component';
import type { Book } from './types';
import Link from '../../Link';

const SearchResult: React.FC<Book> = (props) => (
  <Link to={props.documentUrl}>
    <Front {...props} className="mx-1" scaler={1 / 3} scope="1-3" size="m" />
  </Link>
);

export default SearchResult;
