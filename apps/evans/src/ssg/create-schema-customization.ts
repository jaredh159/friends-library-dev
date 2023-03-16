import fs from 'fs';
import type { GatsbyNode, CreateSchemaCustomizationArgs } from 'gatsby';

const createSchemaCustomization: GatsbyNode['createSchemaCustomization'] = async ({
  actions: { createTypes },
}: CreateSchemaCustomizationArgs) => {
  createTypes(fs.readFileSync(`${__dirname}/schema.graphql`).toString());
};

export default createSchemaCustomization;
