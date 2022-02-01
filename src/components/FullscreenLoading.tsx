import React from 'react';
import Loading from './Loading';

const FullscreenLoading: React.FC = () => (
  <div className="inset-0 absolute h-screen w-full flex items-center justify-center">
    <Loading />
  </div>
);

export default FullscreenLoading;
