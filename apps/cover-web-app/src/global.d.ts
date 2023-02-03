declare module 'react-keyboard-event-handler' {
  const value: any;
  export default value;
}

declare module 'browser-or-node' {
  const isBrowser: boolean;
  const isNode: boolean;
  export { isBrowser, isNode };
}
