import type { StorybookConfig } from '@storybook/nextjs';

const config: StorybookConfig = {
  env: {
    NEXT_PUBLIC_LANG: 'en',
  },
  stories: ['../stories/**/*.stories.tsx'],
  addons: [
    '@storybook/addon-links',
    '@storybook/addon-essentials',
    '@storybook/addon-interactions',
  ],
  framework: {
    name: '@storybook/nextjs',
    options: {},
  },
  docs: {
    autodocs: 'tag',
  },
};
export default config;
