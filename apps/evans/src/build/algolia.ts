import fs from 'fs';
import { sync as glob } from 'glob';
import { safeLoad as ymlToJs } from 'js-yaml';
import algoliasearch from 'algoliasearch';
import { t, translateOptional } from '@friends-library/locale';
import { Friend, Document, PublishedCounts } from './types';
import env from '@friends-library/env';
import { friendUrl, documentUrl } from '../lib/url';
import { LANG } from '../env';
import { PAGE_META_DESCS } from '../lib/seo';
import * as api from './api';

if (process.env.FORCE_ALGOLIA_SEND) {
  require(`@friends-library/env/load`);
  sendSearchDataToAlgolia();
}

export async function sendSearchDataToAlgolia(): Promise<void> {
  const { GATSBY_ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY } = env.require(
    `GATSBY_ALGOLIA_APP_ID`,
    `ALGOLIA_ADMIN_KEY`,
  );

  const counts = await api.queryPublishedCounts();
  const client = algoliasearch(GATSBY_ALGOLIA_APP_ID, ALGOLIA_ADMIN_KEY);
  const friends = (await api.queryFriends())
    .filter((f) => f.lang === LANG)
    .filter((f) => f.hasNonDraftDocument);

  const documentEntities = (await api.queryDocuments())
    .filter(({ friend }) => friend.lang === LANG)
    .filter(({ friend }) => friend.hasNonDraftDocument)
    .filter(({ document }) => document.hasNonDraftEdition);

  const friendsIndex = client.initIndex(`${LANG}_friends`);
  await friendsIndex.replaceAllObjects(friends.map(friendRecord));
  await friendsIndex.setSettings({
    paginationLimitedTo: 24,
    snippetEllipsisText: `[...]`,
    attributesToSnippet: [`description:30`],
    searchableAttributes: [`name`, `bookTitles`, `description`, `residences`],
  });

  const docsIndex = client.initIndex(`${LANG}_docs`);
  await docsIndex.replaceAllObjects(documentEntities.map(documentRecord));
  await docsIndex.setSettings({
    paginationLimitedTo: 24,
    snippetEllipsisText: `[...]`,
    attributesToSnippet: [
      `description:30`,
      `partialDescription:30`,
      `featuredDescription:30`,
    ],
    searchableAttributes: [
      `title`,
      `originalTitle`,
      `description`,
      `partialDescription`,
      `featuredDescription`,
      `authorName`,
      `tags`,
    ],
  });

  const pagesIndex = client.initIndex(`${LANG}_pages`);
  await pagesIndex.replaceAllObjects(
    [...mdxRecords(counts), ...customPageRecords(counts)],
    {
      autoGenerateObjectIDIfNotExist: true,
    },
  );
  await pagesIndex.setSettings({
    paginationLimitedTo: 24,
    snippetEllipsisText: `[...]`,
    attributesToSnippet: [`text:30`],
    searchableAttributes: [`title`, `subtitle`, `text`],
  });
}

function friendRecord(friend: Friend): Record<string, string> {
  return {
    objectID: friend.id,
    name: friend.name,
    url: friendUrl(friend),
    bookTitles:
      `“` +
      friend.documents
        .filter((d) => d.hasNonDraftEdition)
        .map((d) => convertEntities(d.htmlShortTitle))
        .join(`”, “`) +
      `”`,
    residences: friend.residences
      .map((r) => `${translateOptional(r.city)}, ${translateOptional(r.region)}`)
      .join(` — `),
    description: friend.description,
  };
}

function documentRecord({
  document,
  friend,
}: {
  document: Document;
  friend: Friend;
}): Record<string, string | undefined> {
  return {
    objectID: document.id,
    title: convertEntities(document.htmlShortTitle),
    authorName: friend.name,
    url: documentUrl(document, friend),
    originalTitle: document.originalTitle ?? undefined,
    description: document.description,
    partialDescription: document.partialDescription,
    featuredDescription: document.featuredDescription ?? undefined,
    tags: document.tags.join(`, `),
  };
}

function mdxRecords(counts: PublishedCounts): Record<string, string | null>[] {
  const paths = glob(`${__dirname}/../mdx/*.${LANG}.mdx`);
  return paths.flatMap((filePath) => {
    const content = fs.readFileSync(filePath).toString();
    const [, yaml, text] = content.split(/---\n/m);
    const frontmatter = ymlToJs(yaml) as Record<string, string>;
    const records: Record<string, string | null>[] = [
      {
        title: frontmatter.title,
        url: frontmatter.path,
        text: convertEntities(replaceCounts(frontmatter.description, counts)),
      },
    ];
    const paras = removeMarkdownFormatting(
      convertEntities(replaceCounts(text.trim(), counts)),
    )
      .split(`\n\n`)
      .map(sanitizeMdParagraph)
      .filter(Boolean);

    let currentSubtitle: null | string = null;
    for (const para of paras) {
      if (para.startsWith(`#`)) {
        currentSubtitle = para.replace(/^#+ /, ``);
        continue;
      }
      records.push({
        url: frontmatter.path,
        title: frontmatter.title,
        subtitle: currentSubtitle,
        text: para,
      });
    }
    return records;
  });
}

function customPageRecords(counts: PublishedCounts): Record<string, string | null>[] {
  return [
    {
      title: t`Audio Books`,
      url: t`/audiobooks`,
      text: replaceCounts(PAGE_META_DESCS.audiobooks[LANG], counts),
    },
    {
      title: t`Contact Us`,
      url: t`/contact`,
      text: replaceCounts(PAGE_META_DESCS.contact[LANG], counts),
    },
    {
      title: t`Explore Books`,
      url: t`/explore`,
      text: replaceCounts(PAGE_META_DESCS.explore[LANG], counts),
    },
    {
      title: t`All Friends`,
      url: t`/friends`,
      text: replaceCounts(PAGE_META_DESCS.friends[LANG], counts),
    },
    {
      title: t`Getting Started`,
      url: t`/getting-started`,
      text: replaceCounts(PAGE_META_DESCS[`getting-started`][LANG], counts),
    },
  ];
}

function convertEntities(input: string): string {
  return input
    .replace(/&mdash;/g, `—`)
    .replace(/&nbsp;/g, ` `)
    .replace(/&rsquo;/g, `’`)
    .replace(/&lsquo;/g, `‘`)
    .replace(/&rdquo;/g, `”`)
    .replace(/&ldquo;/g, `“`);
}

function removeMarkdownFormatting(md: string): string {
  return md
    .replace(/(\*\*|_)/g, ``)
    .replace(/^> /gm, ``)
    .replace(/{' '}/g, ``)
    .replace(/<.+?>/g, ``)
    .replace(/\[([^\]]+)\]\([^)]+\)/g, `$1`);
}

function sanitizeMdParagraph(paragraph: string): string {
  return paragraph
    .split(`\n`)
    .filter((l) => !l.match(/^<\/?Lead>/))
    .join(` `)
    .replace(/<\/?iframe(.*?)>/g, ``)
    .replace(/ {2,}/g, ` `)
    .replace(/^- /, ``)
    .trim();
}

function replaceCounts(str: string, numPublished: PublishedCounts): string {
  return str
    .replace(/%NUM_ENGLISH_BOOKS%/g, String(numPublished.books.en))
    .replace(/%NUM_SPANISH_BOOKS%/g, String(numPublished.books.es))
    .replace(/%NUM_FRIENDS%/g, String(numPublished.friends[LANG]))
    .replace(/%NUM_UPDATED_EDITIONS%/g, String(numPublished.updatedEditions[LANG]))
    .replace(/%NUM_AUDIOBOOKS%/g, String(numPublished.audioBooks[LANG]));
}
