import QualitySwitch from '@evans/pages/document/QualitySwitch';
import type { Meta, StoryObj } from '@storybook/react';
import { props } from './helpers';

const meta = {
  title: 'Document/QualitySwitch', // eslint-disable-line
  component: () => (
    <div className="flex flex-col gap-4">
      <QualitySwitch quality="hq" onChange={() => {}} />
      <QualitySwitch quality="lq" onChange={() => {}} />
    </div>
  ),
  parameters: {
    layout: `centered`,
    backgrounds: {
      default: `offwhite`,
      values: [{ name: `offwhite`, value: `rgb(240, 240, 240)` }],
    },
  },
} satisfies Meta<typeof QualitySwitch>;

type Story = StoryObj<typeof meta>;

export const Default: Story = props({});

export default meta;
