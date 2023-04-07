import React from 'react';
import type { GetStaticProps } from 'next';

export const getStaticProps: GetStaticProps = async () => {
  return {
    props: {},
  };
};

const Home: React.FC = () => (
  <h1 className="bg-flprimary text-white">
    Home, lang is <code className="text-red-700">{process.env.NEXT_PUBLIC_LANG}</code>
  </h1>
);

export default Home;
