import React, { useState } from 'react';
import { action as a } from '@storybook/addon-actions';
import DocBlock from '@evans/pages/document/DocBlock';
import ListenBlock from '@evans/pages/document/ListenBlock';
import QualitySwitch from '@evans/pages/document/QualitySwitch';
import ChooseEdition from '@evans/pages/document/ChooseEdition';
import ChooseFormat from '@evans/pages/document/ChooseFormat';
import ChooseEbookType from '@evans/pages/document/ChooseEbookType';
import Downloading from '@evans/pages/document/Downloading';
import DownloadWizard from '@evans/pages/document/DownloadWizard';
import DownloadAudiobook from '@evans/pages/document/DownloadAudiobook';
import DownloadOptions from '@evans/DownloadOptions';
import PopUnder from '@evans/PopUnder';
import type { AudioQuality } from '@friends-library/types';
import type { Meta } from '@storybook/react';
import { WebCoverStyles, setBg, fullscreen } from '../decorators';

export default {
  title: 'Site/Pages/Document', // eslint-disable-line
  decorators: [WebCoverStyles],
  parameters: { layout: `centered` },
} as Meta;

export const QualitySwitch_ = () => <StatefulSwitch />;

export const DownloadOptions_ = () => <DownloadOptions />;

export const ChooseFormat_ = () => (
  <PopUnder style={{ width: `22rem`, maxWidth: `100vw` }} tailwindBgColor="flblue">
    <ChooseFormat onChoose={a(`choose format`)} />
  </PopUnder>
);

export const DownloadWizard_ = fullscreen(() => (
  <div style={{ transform: `translate(50%)`, marginTop: 50 }}>
    <DownloadWizard
      editions={[`updated`, `modernized`, `original`]}
      onSelect={a(`select`)}
    />
  </div>
));

export const Downloading_ = () => (
  <PopUnder style={{ width: `22rem`, maxWidth: `100vw` }} tailwindBgColor="flblue">
    <Downloading />
  </PopUnder>
);

export const ChooseEbookType_ = () => (
  <PopUnder style={{ width: `22rem`, maxWidth: `100vw` }} tailwindBgColor="flblue">
    <ChooseEbookType onChoose={a(`choose ebook type`)} />
  </PopUnder>
);

export const ChooseEdition_ = () => (
  <PopUnder style={{ width: `22rem`, maxWidth: `100vw` }} tailwindBgColor="flblue">
    <ChooseEdition
      editions={[`updated`, `modernized`, `original`]}
      onSelect={a(`select`)}
    />
  </PopUnder>
);

export const DownloadAudiobook_ = setBg(`#f1f1f1`, () => {
  const [quality, setQuality] = useState<AudioQuality>(`hq`);
  return (
    <DownloadAudiobook
      complete={true}
      quality={quality}
      setQuality={setQuality}
      mp3ZipFilesizeHq="345MB"
      mp3ZipFilesizeLq="118MB"
      m4bFilesizeHq="413MB"
      m4bFilesizeLq="154MB"
      mp3ZipUrlHq="/"
      mp3ZipUrlLq="/"
      m4bUrlHq="/"
      m4bUrlLq="/"
      podcastUrlHq="/"
      podcastUrlLq="/"
    />
  );
});

export const ListenBlock_ = fullscreen(() => (
  <ListenBlock
    complete={true}
    title="Sweet Track"
    // playlistIdHq={971887117}
    // playlistIdLq={971899285}
    trackIdLq={236087828}
    trackIdHq={236087816}
    numAudioParts={1}
    m4bFilesizeHq="36MB"
    m4bFilesizeLq={`15MB`}
    mp3ZipFilesizeHq={`42MB`}
    mp3ZipFilesizeLq={`17MB`}
    m4bUrlHq={`/`}
    m4bUrlLq={`/`}
    mp3ZipUrlHq={`/`}
    mp3ZipUrlLq={`/`}
    podcastUrlHq={`/`}
    podcastUrlLq={`/`}
  />
));

export const DocBlock_ = fullscreen(
  setBg(`#333`, () => (
    <DocBlock
      isComplete
      lang="en"
      title="The Journal and Writings of Ambrose Rigge"
      htmlTitle="The Journal and Writings of Ambrose Rigge"
      htmlShortTitle="The Journal and Writings of Ambrose Rigge"
      utf8ShortTitle="Journal and Writings of Ambrose Rigge"
      author="Ambrose Rigge"
      size="s"
      pages={[222]}
      edition="modernized"
      blurb={blurb}
      description={blurb}
      showGuides={false}
      isCompilation={false}
      numDownloads={332}
      customCss=""
      isbn="978-1-64476-004-8"
      customHtml=""
      authorUrl="/friend/ambrose-rigge"
      price={499}
      hasAudio={true}
      numChapters={15}
      altLanguageUrl="https://www.bibliotecadelosamigos.org/james-parnell/vida"
      editionId="123abc"
      editions={[]}
    />
  )),
);

const StatefulSwitch: React.FC = () => {
  const [quality, setQuality] = useState<AudioQuality>(`hq`);
  return <QualitySwitch quality={quality} onChange={setQuality} />;
};

const blurb = `Ambrose Rigge (1635-1705) was early convinced of the truth through the preaching of George Fox, and grew to be a powerful minister of the gospel, a faithful elder, and a great sufferer for the cause of Christ. In one of his letters, he writes, "I have been in eleven prisons in this county, one of which held me ten years, four months and upward, besides twice premunired, and once publicly lashed, and many other sufferings too long to relate here." Yet through all he kept the faith, and served the Lord's body even while in bonds, through letters and papers given to encourage and establish the flock. Ambrose Rigge was one of many in his generation who sold all to buy the Pearl of great price, and having found true treasure, he kept it till the end.`;
