import { c, log } from 'x-chalk';
import { gql } from '@friends-library/db';
import client from '../../api-client';
import {
  CreateArtifactProductionVersion,
  CreateArtifactProductionVersionVariables,
} from '../../graphql/CreateArtifactProductionVersion';

interface Argv {
  sha: string;
}

export default async function handler({ sha }: Argv): Promise<void> {
  try {
    const response = await client.mutate<
      CreateArtifactProductionVersion,
      CreateArtifactProductionVersionVariables
    >({ mutation: MUTATION, variables: { input: { version: sha } } });
    if (response.data?.created.id) {
      log(c`\nSuccessfully added version {green ${sha}}\n`);
    } else {
      log(c`\n{red Unexpected error, see raw response below:}`);
      log(c`Response: {gray ${response}}\n`);
      process.exit(1);
    }
  } catch (err: any) {
    if (err.message.includes(`duplicate key value violates unique constraint`)) {
      log(c`\n{red Error: version {yellow ${sha}} already exists, must be unique}\n`);
      process.exit(1);
    } else {
      log(c`\n{red Unexpected error, see detail below:}`);
      log(c`Response: {gray ${err}}\n`);
      process.exit(1);
    }
  }
}

const MUTATION = gql`
  mutation CreateArtifactProductionVersion(
    $input: CreateArtifactProductionVersionInput!
  ) {
    created: createArtifactProductionVersion(input: $input) {
      id
    }
  }
`;
