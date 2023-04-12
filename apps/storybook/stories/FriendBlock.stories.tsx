import type { Meta, StoryObj } from '@storybook/react';
import FriendBlock from '../../next-evans/components/pages/friend/FriendBlock';
import { MEDIUM_LOREM, props } from './helpers';

const meta = {
  title: 'Friend/FriendBlock', // eslint-disable-line
  component: FriendBlock,
} satisfies Meta<typeof FriendBlock>;

type Story = StoryObj<typeof meta>;

export const Male: Story = props({
  name: `George Fox`,
  gender: `male`,
  blurb: MEDIUM_LOREM,
});

export const Female: Story = props({
  name: `Elizabeth Webb`,
  gender: `female`,
  blurb: MEDIUM_LOREM,
});

export default meta;
