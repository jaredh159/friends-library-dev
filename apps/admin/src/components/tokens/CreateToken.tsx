import React from 'react';
import { EditToken } from './EditToken';
import * as empty from '../../lib/empty';

const CreateToken: React.FC = () => {
  return <EditToken token={empty.token()} />;
};

export default CreateToken;
