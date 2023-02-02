import React from 'react';

const Loading: React.FC = () => (
  <div className="w-24 p-2 flex flex-col items-center justify-center">
    <div className="animate-spin-fast border-t-flprimary-500 mt-1 mb-2 rounded-full border-4 border-t-4 border-gray-200 h-8 w-8" />
    <h2 className="animate-pulse text-center text-gray-400 text-xs uppercase font-light antialiased">
      Loading...
    </h2>
  </div>
);

export default Loading;
