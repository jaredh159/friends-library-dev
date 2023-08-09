import matter from 'gray-matter';
import cx from 'classnames';
import { MDXRemote } from 'next-mdx-remote';
import { serialize } from 'next-mdx-remote/serialize';
import invariant from 'tiny-invariant';
import { type MDXRemoteSerializeResult } from 'next-mdx-remote';
import type { GetStaticPaths, GetStaticProps } from 'next';
import { WhiteOverlay } from '../explore';
import HeroImg from '@/public/images/explore-books.jpg';
import * as mdx from '@/lib/mdx';
import { LANG } from '@/lib/env';
import BackgroundImage from '@/components/core/BackgroundImage';

export const getStaticPaths: GetStaticPaths = async () => ({
  paths: mdx
    .fileData()
    .filter((file) => file.lang === LANG)
    .map(({ slug }) => ({ params: { static: slug } })),
  fallback: false,
});

export const getStaticProps: GetStaticProps<Props> = async (context) => {
  const slug = context.params?.static;
  invariant(typeof slug === `string`);
  const source = mdx.source(slug, LANG);
  const { content, data: frontmatter } = matter(source);
  const mdxSource = await serialize(content, { scope: frontmatter });
  return { props: { source: mdxSource, frontmatter } };
};

interface Props {
  source: MDXRemoteSerializeResult;
  frontmatter: Record<string, unknown>;
}

const components: React.ComponentProps<typeof MDXRemote>['components'] = {
  h2: ({ children }) => (
    <h2
      className={cx(
        `bg-flprimary text-white font-sans text-2xl bracketed tracking-widest`,
        `my-12 -mx-10 py-4 px-10`,
        `sm:text-3xl`,
        `md:-mx-16 md:px-16 `,
        `lg:-mx-24 lg:px-24`,
      )}
    >
      {children}
    </h2>
  ),

  p: ({ children }) => (
    <p className="mb-6 pb-1 text-base sm:text-lg leading-loose">{children}</p>
  ),

  li: ({ children }) => <li className="py-2">{children}</li>,

  h3: ({ children }) => (
    <h3 className="font-sans text-flprimary mb-2 text-2xl">{children}</h3>
  ),

  a: (props) => (
    <a className="text-flprimary fl-underline" {...props}>
      {props.children}
    </a>
  ),

  blockquote: ({ children }) => (
    <blockquote
      className={cx(
        `italic tracking-wider bg-flgray-100 leading-loose`,
        `py-4 px-8 my-8`,
      )}
    >
      {children}
    </blockquote>
  ),

  ul: ({ children }) => (
    <ul
      className={cx(
        `diamonds leading-normal bg-flgray-100 text-base sm:text-lg`,
        `py-4 px-16 mb-8`,
      )}
    >
      {children}
    </ul>
  ),

  Lead: ({ children }) => <div className="Lead">{children}</div>,
};

const StaticPage: React.FC<Props> = ({ source, frontmatter }) => (
  <div>
    <BackgroundImage src={HeroImg} fineTuneImageStyles={{ objectFit: `cover` }}>
      <div className="p-8 sm:p-16 lg:p-24 bg-black/60 lg:backdrop-blur-sm">
        <WhiteOverlay>
          <h1 className="heading-text text-2xl sm:text-4xl bracketed text-flprimary">
            {frontmatter.title as string}
          </h1>
        </WhiteOverlay>
      </div>
    </BackgroundImage>
    <div className="MDX p-10 md:px-16 lg:px-24 body-text max-w-6xl mx-auto mt-4">
      <MDXRemote {...source} components={components} />
    </div>
  </div>
);

export default StaticPage;
