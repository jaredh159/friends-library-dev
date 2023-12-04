import type { T } from '@friends-library/pairql/dev';

export type Audio = T.GetAudios.Output[number];

interface FileFsData {
  localFilename: string;
  localPath: string;
  cloudFilename: string;
  cloudPath: string;
}

export interface AudioFsData {
  relPath: string;
  abspath: string;
  derivedPath: string;
  cachedDataPath: string;
  basename: string;
  hash: string;
  hashedBasename: string;
  m4bs: {
    hq: FileFsData;
    lq: FileFsData;
  };
  mp3Zips: {
    hq: FileFsData;
    lq: FileFsData;
  };
  parts: Array<{
    hashedBasename: string;
    basename: string;
    srcCloudPath: string;
    srcLocalPath: string;
    srcLocalFileExists: boolean;
    srcHash: string;
    cachedDataPath: string;
    mp3s: {
      hq: FileFsData;
      lq: FileFsData;
    };
  }>;
}

interface SoundCloudSharedAttrs {
  sharing: `public`;
  embeddable_by: `all`;
  genre: `Audiobooks`;
  downloadable: true;
  label_name: `Friends Library Publishing` | `Biblioteca de los Amigos`;
  permalink: string;
  title: string;
  description: string;
  tags: string[];
  /* we use this unimportant (to us) field to store artwork/mp3 file hashes */
  release?: null | string;
}

// @see https://developers.soundcloud.com/docs/api/explorer/open-api#/tracks/get_tracks__track_id_
// click "Schema"
export type SoundCloudTrack = {
  id: number;
  release: string;
  permalink_url: string;
  tag_list: string;
  user: {
    permalink: string;
  };
};

export type SoundCloudTrackAttrs = SoundCloudSharedAttrs & {
  track_type: `spoken`;
  commentable: false;
};

export type SoundCloudPlaylistAttrs = SoundCloudSharedAttrs & {
  trackIds: number[];
};
