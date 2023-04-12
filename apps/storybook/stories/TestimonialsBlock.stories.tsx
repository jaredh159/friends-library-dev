import type { Meta, StoryObj } from '@storybook/react';
import TestimonialsBlock from '../../next-evans/components/pages/friend/TestimonialsBlock';
import { MEDIUM_LOREM, props } from './helpers';

const meta = {
  title: 'Friend/TestimonialsBlock', // eslint-disable-line
  component: TestimonialsBlock,
  parameters: { layout: `fullscreen` },
} satisfies Meta<typeof TestimonialsBlock>;

type Story = StoryObj<typeof meta>;

export const One: Story = props({
  testimonials: [
    {
      cite: `John Doe`,
      quote: MEDIUM_LOREM,
    },
  ],
});

export const Two: Story = props({
  testimonials: [
    ...One.args.testimonials,
    {
      cite: `Jane Doe`,
      quote: MEDIUM_LOREM,
    },
  ],
});

export const Three: Story = props({
  testimonials: [
    ...Two.args.testimonials,
    {
      cite: `Joe Doe`,
      quote: MEDIUM_LOREM,
    },
  ],
});

export const Four: Story = props({
  testimonials: [
    ...Three.args.testimonials,
    {
      cite: `Jim Doe`,
      quote: MEDIUM_LOREM,
    },
  ],
});

export default meta;
