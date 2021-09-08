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

  return <CreateOrder />;
};

export default App;
