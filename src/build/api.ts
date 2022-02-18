import fetch from 'cross-fetch';
import env from '@friends-library/env';
import { gql, getClient } from '@friends-library/db';
import { Document, Edition, Friend, PublishedCounts } from './types';
import { Friends } from '../graphql/Friends';

type DocumentEntities = {
  document: Document;
  friend: Friend;
};

type EditionEntities = DocumentEntities & {
  edition: Edition;
};

let cachedFriends: Friend[] | null = null;

export async function queryFriends(): Promise<Friend[]> {
  if (cachedFriends) return cachedFriends;
  const TOKEN = env.requireVar(`EVANS_BUILD_FLP_API_TOKEN`);
  const client = getClient({ env: `dev`, fetch, token: TOKEN });
  const { data } = await client.query<Friends>({ query: QUERY });
  cachedFriends = data.friends;
  return data.friends;
}

export async function queryDocuments(): Promise<DocumentEntities[]> {
  const friends = await queryFriends();
  const entities: DocumentEntities[] = [];
  for (const friend of friends) {
    for (const document of friend.documents) {
      entities.push({ document, friend });
    }
  }
  return entities;
}

export async function queryEditions(): Promise<EditionEntities[]> {
  const friends = await queryFriends();
  const entities: EditionEntities[] = [];
  for (const friend of friends) {
    for (const document of friend.documents) {
      for (const edition of document.editions) {
        entities.push({ edition, document, friend });
      }
    }
  }
  return entities;
}

let publishedCounts: PublishedCounts = {
  friends: { en: -1, es: -1 },
  books: { en: -1, es: -1 },
  updatedEditions: { en: -1, es: -1 },
  audioBooks: { en: -1, es: -1 },
};

export async function queryPublishedCounts(): Promise<PublishedCounts> {
  if (publishedCounts.friends.en !== -1) {
    return publishedCounts;
  }

  const friends = await queryFriends();
  const documentEntities = await queryDocuments();
  const editionEntities = await queryEditions();

  publishedCounts.friends.en = friends.filter(
    (f) => f.lang === `en` && f.hasNonDraftDocument,
  ).length;

  publishedCounts.friends.es = friends.filter(
    (f) => f.lang === `es` && f.hasNonDraftDocument,
  ).length;

  publishedCounts.books.en = documentEntities.filter(
    (e) => e.friend.lang === `en` && e.document.hasNonDraftEdition,
  ).length;

  publishedCounts.books.es = documentEntities.filter(
    (e) => e.friend.lang === `es` && e.document.hasNonDraftEdition,
  ).length;

  publishedCounts.updatedEditions.en = editionEntities.filter(
    (e) => e.friend.lang === `en` && !e.edition.isDraft && e.edition.type === `updated`,
  ).length;

  publishedCounts.updatedEditions.es = editionEntities.filter(
    (e) => e.friend.lang === `es` && !e.edition.isDraft && e.edition.type === `updated`,
  ).length;

  publishedCounts.audioBooks.en = editionEntities.filter(
    (e) => e.friend.lang === `en` && !e.edition.isDraft && e.edition.audio,
  ).length;

  publishedCounts.audioBooks.es = editionEntities.filter(
    (e) => e.friend.lang === `es` && !e.edition.isDraft && e.edition.audio,
  ).length;

  return publishedCounts;
}

const QUERY = gql`
  query Friends {
    friends: getFriends {
      id
      lang
      slug
      gender
      name
      born
      died
      description
      isCompilations
      published
      hasNonDraftDocument
      primaryResidence {
        region
        city
      }
      documents {
        id
        title
        htmlTitle
        htmlShortTitle
        utf8ShortTitle
        originalTitle
        slug
        published
        incomplete
        directoryPath
        description
        partialDescription
        featuredDescription
        hasNonDraftEdition
        tags {
          type
        }
        altLanguageDocument {
          slug
          htmlShortTitle
          hasNonDraftEdition
          friend {
            slug
          }
        }
        editions {
          id
          type
          isDraft
          path: directoryPath
          chapters {
            id
          }
          isbn {
            code
          }
          images {
            square {
              w1400 {
                url
              }
            }
          }
          impression {
            paperbackPriceInCents
            paperbackSize
            paperbackVolumes
            createdAt
            files {
              ebook {
                pdf {
                  logUrl
                }
                mobi {
                  logUrl
                }
                epub {
                  logUrl
                }
                speech {
                  logUrl
                }
              }
            }
          }
          audio {
            reader
            isIncomplete
            externalPlaylistIdHq
            externalPlaylistIdLq
            m4bSizeHq
            m4bSizeLq
            mp3ZipSizeHq
            mp3ZipSizeLq
            humanDurationClock
            createdAt
            parts {
              title
              chapters
              duration
              externalIdHq
              externalIdLq
              mp3SizeHq
              mp3SizeLq
              mp3File {
                hq {
                  logUrl
                }
                lq {
                  logUrl
                }
              }
            }
            files {
              m4b {
                hq {
                  logUrl
                }
                lq {
                  logUrl
                }
              }
              mp3s {
                hq {
                  logUrl
                }
                lq {
                  logUrl
                }
              }
              podcast {
                hq {
                  logUrl
                  sourcePath
                }
                lq {
                  logUrl
                  sourcePath
                }
              }
            }
          }
        }
        primaryEdition {
          id
          type
          images {
            threeD {
              w700 {
                url
              }
            }
          }
        }
        relatedDocuments {
          description
          document {
            id
            htmlShortTitle
            description
          }
        }
      }
      relatedDocuments {
        description
        document {
          id
          htmlShortTitle
          description
        }
      }
      quotes {
        source
        text
      }
      residences {
        city
        region
        durations {
          start
          end
        }
      }
    }
  }
`;
