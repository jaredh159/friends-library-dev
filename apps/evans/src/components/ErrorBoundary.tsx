import React from 'react';
import Dual from './Dual';
import { NODE_ENV } from '../env';
import { sendJsError } from './lib/Client';
import { LogJsErrorDataInput } from '../graphql/globalTypes';

interface State {
  hasError: boolean;
}

interface Props {
  location: string;
}

export default class ErrorBoundary extends React.Component<Props, State> {
  state = { hasError: false };

  static getDerivedStateFromError(): State {
    return { hasError: true };
  }

  public componentDidCatch(error: any, errorInfo: any): void {
    if (NODE_ENV === `development`) {
      console.error(error);
      return;
    }

    const data: LogJsErrorDataInput = {
      errorMessage: String(error),
      additionalInfo: errorInfo === undefined ? null : String(errorInfo),
      location: this.props.location,
      url: window.location.href,
      userAgent: navigator.userAgent,
      colNumber: null,
      errorName: null,
      errorStack: null,
      event: null,
      lineNumber: null,
      source: null,
    };

    if (error instanceof Error) {
      data.errorMessage = error.message;
      data.errorName = error.name;
      data.errorStack = error.stack ?? null;
    }

    sendJsError(data);
  }

  render(): React.ReactNode {
    if (this.state.hasError) {
      return (
        <Dual.H1 className="p-6 text-center text-white bg-red-700">
          <>
            Sorry, an unexpected error occurred. We&rsquo;ve been notified of the problem
            and will look into it as soon as possible. Please refresh the page and try
            again. We&rsquo;re very sorry for any inconvenience.
          </>
          <>
            Lo siento, ha ocurrido un error inesperado. Hemos sido notificados sobre el
            problema y lo investigaremos lo antes posible. Actualiza la página e inténtalo
            de nuevo. Lamentamos cualquier inconveniente.
          </>
        </Dual.H1>
      );
    }

    return this.props.children;
  }
}
