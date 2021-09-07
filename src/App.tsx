import React, { useState } from 'react';
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

  return <h1>TODO</h1>;
};

export default App;
