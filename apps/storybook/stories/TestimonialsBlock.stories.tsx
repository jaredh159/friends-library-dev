import type { Meta, StoryObj } from '@storybook/react';
import TestimonialsBlock from '../../next-evans/components/pages/friend/TestimonialsBlock';
import { MEDIUM_LOREM } from './helpers';
import '../styles/globals.css';

const meta = {
  title: 'Friend/TestimonialsBlock', // eslint-disable-line
  component: TestimonialsBlock,
} satisfies Meta<typeof TestimonialsBlock>;

type Story = StoryObj<typeof meta>;

export const One: Story = {
  args: {
    testimonials: [
      {
        cite: `John Doe`,
        quote: MEDIUM_LOREM,
      },
    ],
  },
};

export const Two: Story = {
  args: {
    testimonials: [
      ...One.args.testimonials,
      {
        cite: `Jane Doe`,
        quote: MEDIUM_LOREM,
      },
    ],
  },
};

export const Three: Story = {
  args: {
    testimonials: [
      ...Two.args.testimonials,
      {
        cite: `Joe Doe`,
        quote: MEDIUM_LOREM,
      },
    ],
  },
};

export const Four: Story = {
  args: {
    testimonials: [
      ...Three.args.testimonials,
      {
        cite: `Jim Doe`,
        quote: MEDIUM_LOREM,
      },
    ],
  },
};

export default meta;
