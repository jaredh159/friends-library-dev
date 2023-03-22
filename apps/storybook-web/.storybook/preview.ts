import '../../evans/src/css/tailwind.css';

/* gatsby overrides */
global.___loader = {
  enqueue: () => {},
  hovering: () => {},
};
global.__PATH_PREFIX__ = '';
window.___navigate = (pathname) => {
  action('Navigate to:')(pathname);
};

export const parameters = {
  actions: { argTypesRegex: '^on[A-Z].*' },
};
