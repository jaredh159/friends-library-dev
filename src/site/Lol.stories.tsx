import React from 'react';
import { Meta } from '@storybook/react';
import Button from '../../../evans/src/components/Button';

export default {
  title: `Site/Lol/Lol`,
  component: Button,
} as Meta;

export const Basic = () => <Button>Foo</Button>;
