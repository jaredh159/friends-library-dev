import React from 'react';
import { Story as StoryType } from '@storybook/react';
import {
  CoverWebStylesAllStatic,
  CoverWebStylesSizes,
} from '@friends-library/cover-component';

export function WebCoverStyles(Story: StoryType): JSX.Element {
  return (
    <>
      <Story />
      <CoverWebStylesAllStatic />
      <CoverWebStylesSizes />
    </>
  );
}

export function setLayout(story: any, layout: 'padded' | 'fullscreen' | 'centered'): any {
  story.parameters = {
    ...story.parameters,
    layout,
  };
  return story;
}

export function padded(story: any): any {
  return setLayout(story, `padded`);
}

export function centered(story: any): any {
  return setLayout(story, `centered`);
}

export function fullscreen(story: any): any {
  return setLayout(story, `fullscreen`);
}

export function name(name: string, story: any): any {
  story.storyName = name;
  return story;
}

export function setBg(color: string, story: any, name = `custom`): any {
  story.parameters = {
    ...story.parameters,
    backgrounds: { default: name, values: [{ name, value: color }] },
  };
  return story;
}

export function bgImg<T>(src: T): { aspectRatio: 1; src: T; srcSet: '' } {
  return { aspectRatio: 1, src, srcSet: `` };
}
