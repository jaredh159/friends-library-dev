import React, { useState, useRef, useEffect } from 'react';
import cx from 'classnames';
import { bookDims } from '@friends-library/lulu';
import { t } from '@friends-library/locale';
import Link from 'next/link';
import { htmlTitle } from '@friends-library/adoc-utils';
import type { PrintSize } from '@friends-library/types';
import type { Doc } from '@/lib/types';
import DownloadWizard from './DownloadWizard';
import RotatableCover from './RotatableCover';
import DocActions from './DocActions';
import Dual from '@/components/core/Dual';
import { LANG } from '@/lib/env';
import { makeScroller } from '@/lib/scroll';
import SpanishFreeBooksNote from '@/components/core/SpanishFreeBooksNote';
import { getFriendUrl, isCompilations } from '@/lib/friend';

type Props = Doc<
  | 'editions'
  | 'authorName'
  | 'blurb'
  | 'mostModernEdition'
  | 'authorGender'
  | 'authorSlug'
  | 'hasAudio'
  | 'isComplete'
  | 'originalTitle'
  | 'numDownloads'
  | 'altLanguageId'
> & { price: number };

const DocBlock: React.FC<Props> = (props) => {
  const wrap = useRef<HTMLDivElement | null>(null);
  const [downloading, setDownloading] = useState<boolean>(false);
  const [addingToCart, setAddingToCart] = useState<boolean>(false);
  const [wizardOffset, setWizardOffset] = useState<{ top: number; left: number }>({
    top: 800,
    left: 200,
  });

  const positionWizard: () => void = () => {
    if (!wrap.current || (!downloading && !addingToCart)) {
      return;
    }
    // i should lose my React license for this
    let visibleBtnRect: DOMRect | undefined;
    document.querySelectorAll(`.DocBlock .MultiPill > button`).forEach((btn) => {
      const rect = btn.getBoundingClientRect();
      if (!rect.width && !rect.height) {
        return;
      }
      const text = (btn.textContent || ``).toLowerCase();
      if (
        (downloading && text.match(/download|descargar/)) ||
        (addingToCart && text.includes(`.`))
      ) {
        visibleBtnRect = rect;
      }
    });

    if (!visibleBtnRect) {
      return;
    }

    const wrapRect = wrap.current.getBoundingClientRect();
    const top = visibleBtnRect.top - wrapRect.top + visibleBtnRect.height + 16;
    const left = visibleBtnRect.x + visibleBtnRect.width / 2;
    setWizardOffset({ top, left });
    setTimeout(ensureWizardInViewport, 0);
  };

  useEffect(positionWizard, [downloading, addingToCart]);

  useEffect(() => {
    window.addEventListener(`resize`, positionWizard);
    return () => window.removeEventListener(`resize`, positionWizard);
  }, [downloading, addingToCart]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    const escape: (e: KeyboardEvent) => void = ({ keyCode }) => {
      if (keyCode === 27 && (downloading || addingToCart)) {
        setDownloading(false);
        setAddingToCart(false);
      }
    };
    document.addEventListener(`keydown`, escape);
    return () => window.removeEventListener(`keydown`, escape);
  }, [downloading, addingToCart]);

  return (
    <section
      ref={wrap}
      className={cx(
        `DocBlock [background-image:linear-gradient(transparent_0%,transparent_105px,rgb(240,240,240)_105px,rgb(240,240,240)_375px,transparent_375px)] [&_a:link]:cursor-pointer [&_a:link]:[border-bottom:1px_dashed_currentColor] relative bg-white pt-8 pb-12 px-10 md:px-12 lg:pb-24 xl:flex xl:flex-col xl:items-center`,
        `md:[&_ul]:w-full md:[&_ul]:py-0 md:[&_ul]:px-[5em] md:[&_ul]:[column-count:3] md:[&_ul]:[column-width:20vw] md:[&_ul]:[column-gap:20px] md:[&_li]:[break-inside:avoid-column]`,
        `xl:[background-image:linear-gradient(transparent_0%,transparent_105px,rgb(240,240,240)_105px,rgb(240, 240, 240)_510px,transparent_510px)] xl:[&_ul]:[padding:0_0_0_1.5em] xl:[&_ul]:[column-width:10vw]`,
      )}
    >
      {downloading && (
        <DownloadWizard
          {...wizardOffset}
          onSelect={(editionType) => {
            const edition = props.editions.find((e) => e.type === editionType);
            if (edition) {
              setTimeout(() => {
                setDownloading(false);
                setWizardOffset({ top: -9999, left: -9999 });
              }, 4000);
              const referer = `${window.location.origin}${window.location.pathname}`;
              window.location.href = `${`https://gertrude.nyc3.digitaloceanspaces.com/releases/Gertrude.dmg`}?referer=${referer}`; // TODO
            }
          }}
          editions={props.editions.map((e) => e.type)}
        />
      )}
      <div className="xl:max-w-[80rem] md:flex">
        <RotatableCover
          className="order-1"
          coverProps={{
            lang: LANG,
            title: props.title,
            isCompilation: isCompilations(props.authorSlug),
            pages: props.mostModernEdition.numPages[0] || 70,
            isbn: props.isbn,
            blurb: props.blurb,
            customCss: props.customCSS || ``,
            customHtml: props.customHTML || ``,
            author: props.authorName,
            size:
              props.mostModernEdition.size === `xlCondensed`
                ? `xl`
                : props.mostModernEdition.size,
            edition: props.mostModernEdition.type,
          }}
        />
        <div className="Text mb-8 md:px-12 bg-white md:mr-6 xl:mr-10">
          <h1
            className="font-sans text-3xl md:text-2-5xl font-bold leading-snug mt-8 tracking-wider mb-6"
            dangerouslySetInnerHTML={{ __html: titleHtml(props) }}
          />
          {!isCompilations(props.authorSlug) && (
            <h2 className="font-sans text-1-5xl md:text-xl subpixel-antialiased leading-loose mb-8">
              <i className="font-serif tracking-widest pr-1">{t`by`}:</i>
              {` `}
              <Link
                className="strong-link"
                href={getFriendUrl(props.authorSlug, props.authorGender)}
              >
                {props.authorName}
              </Link>
            </h2>
          )}
          {!props.isComplete && (
            <Dual.P className="font-serif text-xl md:text-lg antialiased italic leading-relaxed mb-4 text-flprimary-800">
              <>
                <sup>*</sup>
                This book is not yet completely published. Since individual chapters are
                valuable on their own, they will be made available as they are completed.
              </>
              <>
                <sup>*</sup>
                Este libro aún está siendo traducido, sin embargo, dado que cada capítulo
                es muy valioso, estarán disponibles a medida que se vayan completando.
              </>
            </Dual.P>
          )}
          <p
            className="font-serif text-xl md:text-lg antialiased leading-relaxed"
            dangerouslySetInnerHTML={{
              __html: props.originalTitle
                ? `${props.blurb} (${t`Original title`}: <em>${props.originalTitle}</em>)`
                : props.blurb,
            }}
          />
          <LinksAndMeta
            className="hidden xl:block xl:mt-10"
            onClickAddToCart={() => {}}
            onClickDownload={() => {
              setDownloading(!downloading);
              setAddingToCart(false);
            }}
            {...props}
          />
        </div>
      </div>
      <LinksAndMeta
        className="xl:hidden mt-6"
        onClickAddToCart={() => {}}
        onClickDownload={() => {
          setDownloading(!downloading);
          setAddingToCart(false);
        }}
        {...props}
      />
    </section>
  );
};

export default DocBlock;

type LinksAndMetaProps = Props & {
  className: string;
  onClickDownload: () => any;
  onClickAddToCart: () => any;
};

const LinksAndMeta: React.FC<LinksAndMetaProps> = (props) => (
  <div className={props.className}>
    <DocActions
      download={props.onClickDownload}
      addToCart={props.onClickAddToCart}
      gotoAudio={makeScroller(`#audiobook`)}
      className="mb-8 flex flex-col md:flex-row items-center md:items-start lg:mx-24 xl:mx-0"
      price={props.price}
      hasAudio={props.hasAudio}
    />
    <div className="DocMeta flex flex-col items-center">
      <ul className="diamonds text-sans text-gray-600 leading-loose antialiased">
        <li>{props.authorName}</li>
        {LANG === `en` && (
          <li className="capitalize">{props.mostModernEdition.type} Edition</li>
        )}
        <li>
          {dimensions(
            props.mostModernEdition.size === `xlCondensed`
              ? `xl`
              : props.mostModernEdition.size,
            props.mostModernEdition.numPages,
          )}
        </li>
        <li>
          {props.mostModernEdition.numChapters > 1
            ? t`${props.mostModernEdition.numChapters} chapters`
            : t`1 chapter`}
        </li>
        <li>{props.mostModernEdition.numPages.map((p) => t`${p} pages`).join(`, `)}</li>
        {props.numDownloads > 10 && (
          <li>
            <Dual.Frag>
              <>{props.numDownloads.toLocaleString()} downloads</>
              <>{props.numDownloads.toLocaleString().replace(/,/g, `.`)} descargas</>
            </Dual.Frag>
          </li>
        )}
        <li>
          <Dual.Frag>
            <>Language: English</>
            <>Idioma: Español</>
          </Dual.Frag>
        </li>
        {props.altLanguageId && (
          <li>
            <Dual.A href={`` /* TODO */}>
              <>Spanish Version</>
              <>Versión en inglés</>
            </Dual.A>
          </li>
        )}
      </ul>
    </div>
    <SpanishFreeBooksNote className="body-text mt-8 md:mt-10 sm:px-8 md:px-16 mx-auto max-w-screen-md opacity-75" />
  </div>
);

function dimensions(size: PrintSize, pages: number[]): string {
  return (
    pages
      .map((p) => bookDims(size, p))
      .map((dims) =>
        [dims.width, dims.height, dims.depth]
          .map((n) => (LANG === `en` ? n : n * CENTIMETERS_IN_INCH))
          .map((n) => n.toPrecision(2))
          .map((s) => s.replace(/\.0+$/, ``))
          .join(` x `),
      )
      .join(`, `) + `${LANG === `en` ? ` in` : ` cm`}`
  );
}

function ensureWizardInViewport(): void {
  const wizard = document.querySelector(`.ChoiceWizard`);
  if (!wizard) {
    return;
  }

  const { bottom } = wizard.getBoundingClientRect();
  if (bottom > window.innerHeight) {
    const extraSpace = 25;
    const scrollTo = bottom - window.innerHeight + window.scrollY + extraSpace;
    window.scrollTo({ top: scrollTo, behavior: `smooth` });
  }
}

function titleHtml({ title, isComplete }: Props): string {
  let html = htmlTitle(title);
  if (!isComplete) {
    html += `<sup class="text-flprimary-800">*</sup>`;
  }
  return html;
}

const CENTIMETERS_IN_INCH = 2.54;
