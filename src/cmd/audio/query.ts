import { Lang } from '@friends-library/types';
import * as api from './api';
import { Audio } from './types';

export async function getAudios(
  lang: Lang | 'both',
  pattern?: string,
  limit?: number,
): Promise<Audio[]> {
  const audios = await api.getAudios();
  return audios
    .filter((audio) => {
      if (lang !== `both` && lang !== audio.edition.document.friend.lang) {
        return false;
      }
      if (pattern && !audio.edition.path.includes(pattern)) {
        return false;
      }
      return true;
    })
    .slice(0, limit ?? Infinity);
}
