import React from 'react';
import ReactDOM from 'react-dom/client';
import { queryParam } from '@htc-class/storylite';
import AllStories from './_stories';
import App from './components/App';

ReactDOM.createRoot(document.getElementById(`root`)!).render(
  queryParam(`storylite`) ? <AllStories /> : <App />,
);
