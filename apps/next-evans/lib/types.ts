import type { EditionType } from '@friends-library/types';
import type { ArrowRightIcon } from '@heroicons/react/24/outline';

export { type EditionType };
export type HeroIcon = typeof ArrowRightIcon;
export type Period = 'early' | 'mid' | 'late';

export type Region =
  | 'Eastern US'
  | 'Western US'
  | 'England'
  | 'Scotland'
  | 'Ireland'
  | 'Other';

export type NewsFeedType =
  | `book`
  | `audiobook`
  | `spanish_translation`
  | `feature`
  | `chapter`;

export type MdxPageFrontmatter = {
  title: string;
  description: string;
};
