import React from 'react';
import { Story, StoryGroup, StoryMeta } from '@htc-class/storylite';
import Progress from '../components/Progress';

const ProgressStories: React.FC = () => (
  <StoryGroup>
    <Story title="Default">
      <Progress
        steps={[
          { description: `Update Friend`, status: `succeeded` },
          { description: `Update Friend Residence #1`, status: `rolling back` },
          { description: `Update Friend Residence #1`, status: `rollback succeeded` },
          { description: `Update Friend Residence #1`, status: `no rollback` },
          { description: `Update Friend Residence #2`, status: `in flight` },
          { description: `Update Document`, status: `rollback failed` },
          { description: `Update Document`, status: `not started` },
          { description: `Update Edition`, status: `not started` },
          { description: `Update Foobar`, status: `failed` },
        ]}
      />
    </Story>
  </StoryGroup>
);

const meta: StoryMeta = {
  name: `<Progress />`,
  component: ProgressStories,
  layout: `padded`,
};

export default meta;
