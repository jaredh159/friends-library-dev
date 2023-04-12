import React from 'react';
import * as empty from '../../lib/empty';
import { EditToken } from './EditToken';

const CreateToken: React.FC = () => <EditToken token={empty.token()} />;

export default CreateToken;
