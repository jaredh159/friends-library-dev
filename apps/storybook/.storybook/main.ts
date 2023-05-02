import { mergeConfig } from 'vite';
import type { StorybookConfig } from '@storybook/react-vite';
import tsConfigPaths from 'vite-tsconfig-paths';

const config: StorybookConfig = {
  async viteFinal(config, { configType }) {
    return mergeConfig(config, {
      define: {
        'process.env': {
          NEXT_PUBLIC_LANG: `en`,
        },
      },
      resolve: {
        alias: {
          '@evans': '../../next-evans/components',
        },
      },
      plugins: [tsConfigPaths()],
    });
  },
  stories: ['../stories/**/*.stories.tsx'],
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
