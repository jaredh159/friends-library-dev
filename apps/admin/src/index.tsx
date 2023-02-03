import React from 'react';
import ReactDOM from 'react-dom/client';
import { ApolloProvider } from '@apollo/client';
import { queryParam } from '@htc-class/storylite';
import AllStories from './_stories';
import App from './components/App';
import client from './client';

ReactDOM.createRoot(document.getElementById(`root`)!).render(
  queryParam(`storylite`) ? (
    <AllStories />
  ) : (
    <ApolloProvider client={client}>
      <App />
    </ApolloProvider>
  ),
);
