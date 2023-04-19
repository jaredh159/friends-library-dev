import { StoryFn } from '@storybook/react';
import {
  CoverWebStylesAllStatic,
  CoverWebStylesSizes,
} from '@friends-library/cover-component';

export default function WebCoverStyles(Story: StoryFn): JSX.Element {
  return (
    <>
      <Story />
      <CoverWebStylesAllStatic />
      <CoverWebStylesSizes />
    </>
  );
}
