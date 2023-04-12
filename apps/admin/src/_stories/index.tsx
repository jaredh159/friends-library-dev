import React from 'react';
import { Stories } from '@htc-class/storylite';
import ProgressStories from './Progress.stories';

const AllStories: React.FC = () => <Stories stories={[ProgressStories]} />;

export default AllStories;
