// @ts-check
import { sendJsError } from './src/components/lib/Client';
import './src/css/fontawesome.css';
import './src/css/tailwind.css';
import './src/css/cover.css';

export function onClientEntry() {
  function addScript(src) {
    const script = document.createElement(`script`);
    script.setAttribute(`defer`, ``);
    script.src = src;
    document.body.appendChild(script);
  }

  try {
    const JSCDN = `https://cdn.jsdelivr.net/npm`;

    // add smoothscroll support for Safari et al
    if (!(`scrollBehavior` in document.documentElement.style)) {
      addScript(`${JSCDN}/smoothscroll-polyfill@0.4.4/dist/smoothscroll.min.js`);
    }

    // add fetch
    if (!(`fetch` in window)) {
      addScript(`${JSCDN}/whatwg-fetch@3.2.0/dist/fetch.umd.min.js`);
    }

    // polyfill document.querySelectorAll().forEach support
    if (window.NodeList && !NodeList.prototype.forEach) {
      // @ts-ignore
      NodeList.prototype.forEach = Array.prototype.forEach;
    }

    // catch uncaught errors
    if (process.env.NODE_ENV !== `development`) {
      window.onerror = (event, source, lineno, colno, err) => {
        sendJsError({
          errorMessage: err.message,
          errorName: err.name,
          errorStack: err.stack,
          event: String(event),
          lineNumber: lineno,
          colNumber: colno,
          location: `window.onerror`,
          source: source,
          url: window.location.href,
          userAgent: navigator.userAgent,
          additionalInfo: null,
        });
      };
    }
  } catch (e) {
    // ¯\_(ツ)_/¯
  }
}
