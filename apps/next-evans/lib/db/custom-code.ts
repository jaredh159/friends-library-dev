import { LANG } from '../env';
import { prisma } from './prisma';

export type CustomCode = { css?: string; html?: string };

// { 'friend-slug/document-slug': { css?: string; html?: string }, ... }
let codePromise: Promise<Record<string, CustomCode>> | null = null;

let friendDocumentsPromise: Promise<Record<string, string[]>> | null = null;

export async function getAllCustomCode(): Promise<Record<string, CustomCode>> {
  if (codePromise) {
    process.stdout.write(`cache used!\n`);
    return codePromise;
  }
  process.stdout.write(`fetching custom code...\n`);
  const friendDocuments = await getFriendDocuments();
  const customCode = await Promise.all(
    Object.entries(friendDocuments).map(([friendSlug, documentSlugs]) =>
      _getCustomCode(friendSlug, documentSlugs).then((code) =>
        Object.entries(code).reduce<Record<string, CustomCode>>(
          (acc, [documentSlug, { css, html }]) => {
            acc[`${friendSlug}/${documentSlug}`] = { css, html };
            return acc;
          },
          {},
        ),
      ),
    ),
  );
  const code = customCode.reduce((acc, code) => ({ ...acc, ...code }), {});
  codePromise = Promise.resolve(code);
  return customCode.reduce((acc, code) => ({ ...acc, ...code }), {});
}

async function getFriendDocuments(): Promise<Record<string, string[]>> {
  if (friendDocumentsPromise) {
    return friendDocumentsPromise;
  }
  friendDocumentsPromise = _getFriendDocuments();
  return friendDocumentsPromise;
}

async function _getFriendDocuments(): Promise<Record<string, string[]>> {
  const friends = await prisma.friends.findMany({
    where: {
      lang: LANG,
    },
    select: {
      slug: true,
      documents: {
        where: {
          editions: {
            some: {
              is_draft: false,
            },
          },
        },
        select: {
          slug: true,
        },
      },
    },
  });
  return friends.reduce<Record<string, string[]>>((acc, friend) => {
    acc[friend.slug] = friend.documents.map((doc) => doc.slug);
    return acc;
  }, {});
}

async function _getCustomCode(
  friendSlug: string,
  documentSlugs: string[],
): Promise<Record<string, CustomCode>> {
  const codes = await Promise.all(
    documentSlugs.map((documentSlug) =>
      Promise.all([
        getCode(friendSlug, documentSlug, `css`),
        getCode(friendSlug, documentSlug, `html`),
      ]).then(([css, html]) => ({ css, html, slug: documentSlug })),
    ),
  );
  return codes.reduce((acc: Record<string, { css?: string; html?: string }>, code) => {
    acc[code.slug] = { css: code.css, html: code.html };
    return acc;
  }, {});
}

async function getCode(
  friendSlug: string,
  documentSlug: string,
  type: 'css' | 'html',
): Promise<string | undefined> {
  const res = await fetch(
    `https://raw.githubusercontent.com/${
      LANG === `en` ? `friends-library` : `biblioteca-de-los-amigos`
    }/${friendSlug}/master/${documentSlug}/paperback-cover.${type}`,
  );
  if (res.status === 404) {
    return undefined;
  }
  return res.text();
}
