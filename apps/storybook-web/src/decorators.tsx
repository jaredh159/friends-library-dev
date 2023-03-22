import React from 'react';
import {
  CoverWebStylesAllStatic,
  CoverWebStylesSizes,
} from '@friends-library/cover-component';
import type { Story as StoryType, StoryFn } from '@storybook/react';

export function WebCoverStyles(Story: StoryType): JSX.Element {
  return (
    <>
      <Story />
      <CoverWebStylesAllStatic />
      <CoverWebStylesSizes />
    </>
  );
}

export function setLayout(story: StoryFn, layout: 'fullscreen' | 'centered'): StoryFn {
  story.parameters = {
    ...story.parameters,
    layout,
  };
  return story;
}

export function centered(story: StoryFn): StoryFn {
  return setLayout(story, `centered`);
}

export function fullscreen(story: StoryFn): StoryFn {
  return setLayout(story, `fullscreen`);
}

export function name(name: string, story: StoryFn): any {
  story.storyName = name;
  return story;
}

export function setBg(color: string, story: StoryFn, name = `custom`): any {
  story.parameters = {
    ...story.parameters,
    backgrounds: { default: name, values: [{ name, value: color }] },
  };
  return story;
}

export function bgImg<T>(src: T): { aspectRatio: 1; src: T; srcSet: '' } {
  return { aspectRatio: 1, src, srcSet: `` };
}
