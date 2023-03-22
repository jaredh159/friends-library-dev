import { mergeConfig } from 'vite';

// module.exports = {
//   async viteFinal(config, { configType }) {
//     return mergeConfig(config, {
//       // fix next/link issue with process.env not defined (build only)
//       // https://github.com/storybookjs/storybook/issues/18920#issuecomment-1310273755
//       // check if still necessary when upgrading to next 13
//       define: { 'process.env': {} },
//     });
//   },
import type { StorybookConfig } from '@storybook/react-vite';

const config: StorybookConfig = {
  async viteFinal(config, { configType }) {
    return mergeConfig(config, {
      // fix next/link issue with process.env not defined (build only)
      // https://github.com/storybookjs/storybook/issues/18920#issuecomment-1310273755
      // check if still necessary when upgrading to next 13
      define: { 'process.env': {} },
    });
  },
  stories: ['../src/**/*.stories.tsx'],
  addons: [
    '@storybook/addon-links',
    '@storybook/addon-essentials',
    '@storybook/addon-interactions',
  ],
  framework: '@storybook/react-vite',
  docs: {
    autodocs: 'tag',
  },
};

export default config;
