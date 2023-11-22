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
  title: `Cool book`,
  isIncomplete: false,
  numAudioParts: 1,
  m4bFilesize: { hq: 109234783, lq: 40698958 },
  mp3ZipFilesize: { hq: 54304578, lq: 30735831 },
  m4bLoggedDownloadUrl: { hq: ``, lq: `` },
  mp3ZipLoggedDownloadUrl: { hq: ``, lq: `` },
  podcastLoggedDownloadUrl: { hq: ``, lq: `` },
  embedId: { hq: 3, lq: 4 },
  // setQuality: () => {},
});

export default meta;
