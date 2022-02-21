import React, { useState } from 'react';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Breadcrumbs from './Breadcrumbs';
import CreateOrder from './orders/CreateOrder';
import ListFriends from './entities/ListFriends';
import SignIn from './SignIn';
import Home from './Home';
import EditFriend from './entities/EditFriend';
import EditDocument from './entities/EditDocument';
import ListDocuments from './entities/ListDocuments';
import CreateFriend from './entities/CreateFriend';
import ListTokens from './tokens/ListTokens';
import EditToken from './tokens/EditToken';
import CreateToken from './tokens/CreateToken';

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
    <div className="flex flex-col items-center p-10" style={{ minHeight: `100vh` }}>
      <div className="w-1/2 min-w-[800px]">
        <BrowserRouter>
          <Breadcrumbs />
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/orders/new" element={<CreateOrder />} />
            <Route path="/friends" element={<ListFriends />} />
            <Route path="/friends/new" element={<CreateFriend />} />
            <Route path="/friends/:id" element={<EditFriend />} />
            <Route path="/documents" element={<ListDocuments />} />
            <Route path="/documents/:id" element={<EditDocument />} />
            <Route path="/tokens" element={<ListTokens />} />
            <Route path="/tokens/:id" element={<EditToken />} />
            <Route path="/tokens/new" element={<CreateToken />} />
          </Routes>
        </BrowserRouter>
      </div>
    </div>
  );
};

export default App;
