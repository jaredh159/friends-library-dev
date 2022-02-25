import React from 'react';
import gql from 'x-syntax';
import { graphql } from 'gatsby';
import ContactFormBlock from '../components/pages/contact/FormBlock';
import { t } from '@friends-library/locale';
import { PAGE_META_DESCS } from '../lib/seo';
import { Layout, Seo } from '../components/data';
import { LANG } from '../env';
import { FluidBgImageObject } from '../types';
import Client from '../components/lib/Client';
import {
  SubmitContactForm,
  SubmitContactFormVariables,
} from '../graphql/SubmitContactForm';
import { Lang, Subject as ContactFormSubject } from '../graphql/globalTypes';

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
    <ContactFormBlock bgImg={data.books.image.fluid} onSubmit={submit} />
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

async function submit(
  name: string,
  email: string,
  message: string,
  subject: ContactFormSubject,
): Promise<boolean> {
  try {
    const result = await new Client().mutate<
      SubmitContactForm,
      SubmitContactFormVariables
    >({
      mutation: SUBMIT_MUTATION,
      variables: {
        input: {
          lang: LANG === `es` ? Lang.es : Lang.en,
          name,
          email,
          message,
          subject,
        },
      },
    });
    return result.success;
  } catch {
    return false;
  }
}

const SUBMIT_MUTATION = gql`
  mutation SubmitContactForm($input: SubmitContactFormInput!) {
    result: submitContactForm(input: $input) {
      success
    }
  }
`;
