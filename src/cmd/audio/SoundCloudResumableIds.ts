import { AudioQuality } from '@friends-library/types';
import os from 'os';
import fs from 'fs';

type Data = {
  playlistIdHq: Int64 | null;
  playlistIdLq: Int64 | null;
  parts: Array<{
    idHq: Int64 | null;
    idLq: Int64 | null;
  }>;
};

type Cache = { timestamp: number; data: Data };

export default class SoundCloudResumableIds {
  private id: UUID;
  private data: Data = {
    playlistIdHq: null,
    playlistIdLq: null,
    parts: [],
  };

  public constructor(audioId: UUID) {
    this.id = audioId;
    const cached = this.getCache();
    if (cached && Date.now() - cached.timestamp < SIX_HOURS_MS) {
      this.data = cached.data;
    }
  }

  public setPlaylistId(quality: AudioQuality, id: Int64): void {
    this.data[quality === `HQ` ? `playlistIdHq` : `playlistIdLq`] = id;
    this.persist();
  }

  public getPlaylistId(quality: AudioQuality): Int64 | null {
    return this.data[quality === `HQ` ? `playlistIdHq` : `playlistIdLq`];
  }

  public getPartId(index: number, quality: AudioQuality): Int64 | null {
    return this.data.parts[index]?.[quality === `HQ` ? `idHq` : `idLq`] ?? null;
  }

  public setPartId(index: number, quality: AudioQuality, id: Int64): void {
    const part = this.data.parts[index] ?? { idLq: null, idHq: null };
    part[quality === `HQ` ? `idHq` : `idLq`] = id;
    this.data.parts[index] = part;
    this.persist();
  }

  public destroy(): void {
    fs.rmSync(this.cacheLocation());
  }

  // helpers

  private persist(): void {
    const cache: Cache = { timestamp: Date.now(), data: this.data };
    fs.writeFileSync(this.cacheLocation(), JSON.stringify(cache));
  }

  private getCache(): Cache | null {
    if (fs.existsSync(this.cacheLocation())) {
      return JSON.parse(fs.readFileSync(this.cacheLocation(), `utf8`));
    } else {
      return null;
    }
  }

  private cacheLocation(): string {
    return `${os.tmpdir()}/soundcloud-resumable-progress-${this.id}.json`;
  }
}

// helpers

const SIX_HOURS_MS = 60 * 60 * 6 * 1000;
