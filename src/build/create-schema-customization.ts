import fs from 'fs';
import { GatsbyNode, CreateSchemaCustomizationArgs } from 'gatsby';

const createSchemaCustomization: GatsbyNode['createSchemaCustomization'] = async ({
  actions: { createTypes },
}: CreateSchemaCustomizationArgs) => {
  // TODO... necessary?
  // createTypes(fs.readFileSync(`${__dirname}/schema.graphql`).toString());
};

export default createSchemaCustomization;
