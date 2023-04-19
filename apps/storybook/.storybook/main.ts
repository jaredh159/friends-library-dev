import { mergeConfig } from 'vite';
import type { StorybookConfig } from '@storybook/react-vite';

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
  env: {
    NEXT_PUBLIC_LANG: `en`,
  },
};
export default config;
