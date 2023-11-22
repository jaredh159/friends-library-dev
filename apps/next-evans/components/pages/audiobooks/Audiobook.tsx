import React from 'react';
import cx from 'classnames';
import { t } from '@friends-library/locale';
import Link from 'next/link';
import type { EditionType } from '@/lib/types';
import Album from '@/components/core/Album';
import AudioDuration from '@/components/core/AudioDuration';
import Button from '@/components/core/Button';

interface Props {
  className?: string;
  htmlShortTitle: string;
  bgColor: 'blue' | 'maroon' | 'gold' | 'green';
  editionType: EditionType;
  isbn: string;
  title: string;
  customCss?: string;
  customHtml?: string;
  isCompilation: boolean;
  friendName: string;
  duration: string;
  friendUrl: string;
  documentUrl: string;
  description: string;
}

const Audiobook: React.FC<Props> = ({
  description,
  className,
  bgColor,
  documentUrl,
  htmlShortTitle,
  duration,
  ...props
}) => (
  <div
    className={cx(
      className,
      `Audiobook flex flex-col items-center max-w-[380px] px-6 sm:px-8 py-8 rounded-lg`,
      // purgeCSS: bg-flblue bg-flmaroon bg-flgold bg-flgreen
      `bg-fl${bgColor} text-white`,
    )}
  >
    <Album className="-mt-32" {...props} />
    <div className="flex flex-col justify-center items-center gap-6 flex-grow mt-4">
      <h3
        key="title"
        className="text-lg sans-wider text-center"
        dangerouslySetInnerHTML={{ __html: htmlShortTitle }}
      />
      <h4 className="-mt-3" key="author">
        <Link href={documentUrl} className="fl-underline">
          {props.friendName}
        </Link>
      </h4>
      <AudioDuration textColor="white" key="duration">
        {duration}
      </AudioDuration>
      <p className="body-text text-white -mt-2 flex-grow text-center" key="desc">
        {description}
      </p>
      <Button
        key="button"
        to={`${documentUrl}#audiobook`}
        bg={null}
        className="!text-black bg-flgray-200 hover:bg-white mx-auto mt-auto"
      >
        {t`Listen`}
      </Button>
    </div>
  </div>
);

export default Audiobook;
