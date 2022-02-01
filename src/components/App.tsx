import React, { useState } from 'react';
import CreateOrder from './CreateOrder';
import SignIn from './SignIn';

const App: React.FC = () => {
  const [token, setToken] = useState<string | null>(localStorage.getItem(`token`));
  if (token === null) {
    return (
      <SignIn
        setToken={(newToken) => {
          localStorage.setItem(`token`, newToken);
          setToken(newToken);
        }}
      />
    );
  }

  return (
    <div className="flex flex-col items-center p-12" style={{ minHeight: `100vh` }}>
      <div className="w-1/2 min-w-[600px]">
        <CreateOrder />
      </div>
    </div>
  );
};

export default App;
