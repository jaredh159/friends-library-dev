import type { Meta, StoryObj } from '@storybook/react';
import FriendBlock from '../../next-evans/components/pages/friend/FriendBlock';
import { MEDIUM_LOREM } from './helpers';
import '../styles/globals.css';

const meta = {
  title: 'Friend/FriendBlock', // eslint-disable-line
  component: FriendBlock,
} satisfies Meta<typeof FriendBlock>;

type Story = StoryObj<typeof meta>;

export const Male: Story = {
  args: {
    name: `George Fox`,
    gender: `male`,
    blurb: MEDIUM_LOREM,
  },
};

export const Female: Story = {
  args: {
    name: `Elizabeth Webb`,
    gender: `female`,
    blurb: MEDIUM_LOREM,
  },
};

export default meta;
