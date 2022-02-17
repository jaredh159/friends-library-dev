import fetch from 'cross-fetch';
import env from '@friends-library/env';
import { gql, getClient } from '@friends-library/db';
import { Friend } from './types';
import { Friends } from '../graphql/Friends';

export async function queryFriends(): Promise<Friend[]> {
  const TOKEN = env.requireVar(`EVANS_BUILD_FLP_API_TOKEN`);
  const client = getClient({ env: `dev`, fetch, token: TOKEN });
  const { data } = await client.query<Friends>({ query: QUERY });
  return data.friends;
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
        htmlTitle
        htmlShortTitle
        utf8ShortTitle
        originalTitle
        slug
        published
        incomplete
        description
        directoryPath
        partialDescription
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
              externalIdHq
              externalIdLq
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
                }
                lq {
                  logUrl
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
