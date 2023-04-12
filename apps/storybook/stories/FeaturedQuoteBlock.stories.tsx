import type { Meta, StoryObj } from '@storybook/react';
import FeaturedQuoteBlock from '../../next-evans/components/pages/friend/FeaturedQuoteBlock';
import '../styles/globals.css';
import { LONG_LOREM, SHORT_LOREM } from './helpers';

const meta = {
  title: 'Friend/FeaturedQuoteBlock', // eslint-disable-line
  component: FeaturedQuoteBlock,
} satisfies Meta<typeof FeaturedQuoteBlock>;

type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    quote: SHORT_LOREM,
    cite: `John Doe (on his death bed)`,
  },
};

export const Long: Story = {
  args: {
    quote: LONG_LOREM,
    cite: `John Doe (on his death bed)`,
  },
};

export default meta;
