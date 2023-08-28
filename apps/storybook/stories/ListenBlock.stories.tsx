import ListenBlock from '@evans/pages/document/ListenBlock';
import type { Meta, StoryObj } from '@storybook/react';
import { props } from './helpers';

const meta = {
  title: 'Document/ListenBlock', // eslint-disable-line
  component: ListenBlock,
  parameters: {
    layout: `fullscreen`,
  },
} satisfies Meta<typeof ListenBlock>;

type Story = StoryObj<typeof meta>;

export const Default: Story = props({
  title: 'Cool book',
  trackIdLq: 1406554699,
  trackIdHq: 1406554699,
  numAudioParts: 1,
  className: '',
  complete: true,
  m4bFilesizeLq: '',
  m4bFilesizeHq: '44 MB',
  mp3ZipFilesizeLq: '',
  mp3ZipFilesizeHq: '12 MB',
  m4bUrlLq: '',
  m4bUrlHq: '',
  mp3ZipUrlLq: '',
  mp3ZipUrlHq: '',
  podcastUrlLq: '',
  podcastUrlHq: '',
  quality: 'HQ',
  setQuality: () => {},
});

export default meta;
