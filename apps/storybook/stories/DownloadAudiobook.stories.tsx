import DownloadAudiobook from '@evans/pages/document/DownloadAudiobook';
import type { Meta, StoryObj } from '@storybook/react';
import { props } from './helpers';

const meta = {
  title: 'Document/DownloadAudiobook', // eslint-disable-line
  component: DownloadAudiobook,
  parameters: {
    layout: `centered`,
    backgrounds: {
      default: `offwhite`,
      values: [{ name: `offwhite`, value: `rgb(240, 240, 240)` }],
    },
  },
} satisfies Meta<typeof DownloadAudiobook>;

type Story = StoryObj<typeof meta>;

export const Default: Story = props({
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
