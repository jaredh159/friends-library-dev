import * as React from 'react';
import ReactDOM from 'react-dom/client';
import { Provider } from 'react-redux';
import store from './store';
import App from './App';
import './index.css';

store().then((store) => {
  // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
  ReactDOM.createRoot(document.getElementById(`root`)!).render(
    <Provider store={store}>
      <App />
    </Provider>,
  );
});