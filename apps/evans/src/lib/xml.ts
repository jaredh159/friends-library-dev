import { encode } from 'he';
import moment from 'moment';
import type { AudioQuality } from '@friends-library/types';
import type { Audio, Document, Edition, AudioPart, Friend } from '../ssg/types';
import { LANG, APP_URL } from '../env';

export async function podcast(
  edition: Edition,
  document: Document,
  friend: Friend,
  qualityType: AudioQuality,
): Promise<string> {
  const audio = edition.audio!;
  const quality = qualityType === `hq` ? `hq` : `lq`;
  const launchDate = moment(`2020-03-27`);
  const imageUrl = edition.podcastImageUrl;
  const podcastUrl = quality === `hq` ? audio.podcastLogUrlHq : audio.podcastLogUrlLq;

  return `<?xml version="1.0" encoding="UTF-8"?>
<rss
  xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
  xmlns:atom="http://www.w3.org/2005/Atom"
  version="2.0"
>
  <channel>
    <atom:link
      href="${podcastUrl}"
      rel="self"
      type="application/rss+xml"
    />
    <title>${encode(document.title)}</title>
    <itunes:subtitle>${subtitle(audio, document, friend)}</itunes:subtitle>
    <link>${podcastUrl}</link>
    <language>${LANG}</language>
    <itunes:author>${encode(friend.name)}</itunes:author>
    <description>${encode(document.description)}</description>
    <itunes:summary>${encode(document.description)}</itunes:summary>
    <itunes:explicit>clean</itunes:explicit>
    <itunes:type>episodic</itunes:type>
    <itunes:complete>Yes</itunes:complete>
    <itunes:owner>
      <itunes:name>Jared Henderson</itunes:name>
      <itunes:email>jared.thomas.henderson@gmail.com</itunes:email>
    </itunes:owner>
    <itunes:image href="${imageUrl}" />
    <image>
      <url>${imageUrl}</url>
      <title>${encode(document.title)}</title>
      <link>${podcastUrl}</link>
    </image>
    <itunes:category text="Religion &amp; Spirituality">
      <itunes:category text="Christianity" />
    </itunes:category>
    ${audio.parts
      .map((part, index) => {
        const num = index + 1;
        const desc = partDesc(part, document, friend, num, audio.parts.length);
        return `<item>
      <title>${partTitle(document, num, audio.parts.length)}</title>
      <enclosure
        url="${quality === `hq` ? part.mp3FileLogUrlHq : part.mp3FileLogUrlLq}"
        length="${part[quality === `hq` ? `mp3SizeHq` : `mp3SizeLq`]}"
        type="audio/mpeg"
      />
      <itunes:author>${encode(friend.name)}</itunes:author>
      <itunes:summary>${desc}</itunes:summary>
      <itunes:subtitle>${desc}</itunes:subtitle>
      <description>${desc}</description>
      <guid isPermaLink="false">${
        quality === `hq` ? audio.podcastSourcePathHq : audio.podcastSourcePathLq
      } pt-${num} at ${APP_URL}</guid>
      <pubDate>${(moment(audio.createdAt).isBefore(launchDate)
        ? launchDate
        : moment(audio.createdAt)
      ).format(`ddd, DD MMM YYYY hh:mm:ss ZZ`)}</pubDate>
      <itunes:duration>${part.duration}</itunes:duration>
      <itunes:order>${num}</itunes:order>
      <itunes:explicit>clean</itunes:explicit>
      <itunes:episodeType>full</itunes:episodeType>
    </item>`;
      })
      .join(`\n    `)}
  </channel>
</rss>
`;
}

export function subtitle(
  audio: Pick<Audio, 'reader'>,
  document: Pick<Document, 'title'>,
  friend: Pick<Friend, 'isCompilations' | 'name' | 'lang'>,
): string {
  if (friend.lang === `es`) {
    return `Audiolibro de "${document.title}"${
      friend.isCompilations ? `` : ` escrito por ${friend.name}`
    }, de la Biblioteca de los Amigos. Leído por ${audio.reader}.`;
  }
  return `Audiobook of ${friend.isCompilations ? `` : `${friend.name}'s `}"${
    document.title
  }" from The Friends Library. Read by ${audio.reader}.`;
}

export function partDesc(
  part: Pick<AudioPart, 'title'>,
  document: Pick<Document, 'title'>,
  friend: Pick<Friend, 'name' | 'lang'>,
  partNumber: number,
  numParts: number,
): string {
  const lang = friend.lang;
  const by = lang === `en` ? `by` : `escrito por`;
  const Of = lang === `en` ? `of` : `de`;
  const Part = lang === `en` ? `Part` : `Parte`;
  const byLine = `"${encode(document.title)}" ${by} ${encode(friend.name)}`;
  if (numParts === 1) {
    return lang === `en` ? `Audiobook version of ${byLine}` : `Audiolibro de ${byLine}`;
  }

  let desc = [
    `${Part} ${partNumber} ${Of} ${numParts}`,
    lang === `en` ? `of the audiobook version of` : `del audiolibro de`,
    byLine,
  ].join(` `);

  if (part.title !== `${Part} ${partNumber}`) {
    desc = `${part.title}. ${desc}`;
  }

  desc = desc.replace(/^Chapter (\d)/, `Ch. $1`);
  desc = desc.replace(/^Capítulo (\d)/, `Cp. $1`);

  return desc;
}

export function partTitle(
  document: Pick<Document, 'title'>,
  partNumber: number,
  numParts: number,
): string {
  if (numParts === 1) {
    return document.title;
  }
  return `${document.title}, pt. ${partNumber}`;
}
