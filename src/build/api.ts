import fetch from 'cross-fetch';
import env from '@friends-library/env';
import { gql, getClient } from '@friends-library/db';
import { Document, Edition, Friend } from './types';
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
      hasNonDraftDocument
      primaryResidence {
        region
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
        document {
          id
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
