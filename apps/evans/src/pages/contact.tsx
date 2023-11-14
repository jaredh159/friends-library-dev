import React from 'react';
import EvansClient from '@friends-library/pairql/evans';
import { graphql } from 'gatsby';
import { t } from '@friends-library/locale';
import type { FluidBgImageObject } from '../types';
import ContactFormBlock from '../components/pages/contact/FormBlock';
import { PAGE_META_DESCS } from '../lib/seo';
import { Layout, Seo } from '../components/data';
import { LANG } from '../env';

interface Props {
  data: {
    books: {
      image: {
        fluid: FluidBgImageObject;
      };
    };
  };
}

const ContactPage: React.FC<Props> = ({ data }) => (
  <Layout>
    <Seo title={t`Contact Us`} description={PAGE_META_DESCS.contact[LANG]} />
    <ContactFormBlock
      bgImg={data.books.image.fluid}
      onSubmit={async (name, email, message, subject) => {
        const client = EvansClient.web(window.location.href, () => undefined);
        const result = await client.submitContactForm({
          lang: LANG === `es` ? `es` : `en`,
          name,
          email,
          message,
          subject,
        });
        return result.isSuccess;
      }}
    />
  </Layout>
);

export default ContactPage;

export const query = graphql`
  query ContactFormBg {
    books: file(relativePath: { eq: "Books7.jpg" }) {
      image: childImageSharp {
        fluid(quality: 90, maxWidth: 1920) {
          ...GatsbyImageSharpFluid_withWebp
        }
      }
    }
  }
`;
