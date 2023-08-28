import DocBlock from '@evans/pages/document/DocBlock';
import type { Meta, StoryObj } from '@storybook/react';
import { props } from './helpers';
import WebCoverStyles from 'decorators/CoverStyles';

const meta = {
  title: 'Document/DocBlock',
  component: DocBlock,
  parameters: {
    layout: `fullscreen`,
  },
  decorators: [WebCoverStyles],
} satisfies Meta<typeof DocBlock>;

type Story = StoryObj<typeof meta>;

export const Default: Story = props({
  authorSlug: 'john-doe',
  authorName: 'John Doe',
  authorGender: 'male',
  title: 'The Life and Letters of John Doe',
  blurb: `Lorem ipsum dolor sit amet consectetur, adipisicing elit. Deserunt veniam modi, sed distinctio quam ratione praesentium qui vero soluta labore, saepe assumenda officiis voluptatum, iure numquam id dicta maiores ipsum? Lorem ipsum dolor sit amet consectetur, adipisicing elit. Deserunt veniam modi, sed distinctio quam ratione praesentium qui vero soluta labore, saepe assumenda officiis voluptatum, iure numquam id dicta maiores ipsum?`,
  numPages: [300],
  editions: [],
  isComplete: true,
  numDownloads: 300,
  hasAudio: true,
  price: 300,
  alternateLanguageSlug: null,
  mostModernEdition: {
    type: `modernized`,
    id: `abc123`,
    numPages: [300],
    numChapters: 10,
    size: 'm',
    audioBook: null,
    impressionCreatedAt: `2021-01-01`,
  },
});

export default meta;
