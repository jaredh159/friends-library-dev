import React, { useState, useRef, useEffect } from 'react';
import Link from 'gatsby-link';
import { CoverProps, PrintSize, EditionType } from '@friends-library/types';
import { bookDims } from '@friends-library/lulu';
import { t } from '@friends-library/locale';
import DownloadWizard from './DownloadWizard';
import AddToCartWizard from './AddToCartWizard';
import Dual from '../../Dual';
import { LANG } from '../../env';
import DocActions from './DocActions';
import CartItem from '../../checkout/models/CartItem';
import CartStore from '../../checkout/services/CartStore';
import SpanishFreeBooksNote from '../../SpanishFreeBooksNote';
import RotatableCover from './RotatableCover';
import { makeScroller } from '../../lib/scroll';
import './DocBlock.css';

type Props = Omit<CoverProps, 'pages'> & {
  htmlTitle: string;
  htmlShortTitle: string;
  authorUrl: string;
  documentId: string;
  author: string;
  price: number;
  hasAudio: boolean;
  description: string;
  numChapters: number;
  altLanguageUrl?: string | null;
  pages: number[];
  editions: {
    title: string[];
    interiorPdfUrl: string[];
    coverPdfUrl: string[];
    type: EditionType;
    printSize: PrintSize;
    numPages: number[];
    downloadUrl: {
      web_pdf: string;
      mobi: string;
      epub: string;
    };
  }[];
};

const store = CartStore.getSingleton();

const DocBlock: React.FC<Props> = props => {
  const { authorUrl, pages, author, description, editions } = props;
  const wrap = useRef<HTMLDivElement | null>(null);
  const [downloading, setDownloading] = useState<boolean>(false);
  const [addingToCart, setAddingToCart] = useState<boolean>(false);
  const [recoEbookType, setRecoEbookType] = useState<'epub' | 'mobi'>('epub');
  const [wizardOffset, setWizardOffset] = useState<{ top: number; left: number }>({
    top: -9999,
    left: -9999,
  });

  const positionWizard: () => void = () => {
    if (!wrap.current || (!downloading && !addingToCart)) {
      return;
    }
    // i should lose my React license for this
    let visibleBtnRect: DOMRect | undefined;
    document.querySelectorAll('.DocBlock .MultiPill > button').forEach(btn => {
      const rect = btn.getBoundingClientRect();
      if (!rect.width && !rect.height) {
        return;
      }
      const text = (btn.textContent || '').toLowerCase();
      if (
        (downloading && text.match(/download|descargar/)) || // @TODO check spanish!
        (addingToCart && text.includes('.'))
      ) {
        visibleBtnRect = rect;
      }
    });

    if (!visibleBtnRect) {
      return;
    }

    const wrapRect = wrap.current.getBoundingClientRect();
    const top =
      visibleBtnRect.top -
      wrapRect.top +
      visibleBtnRect.height +
      POPUNDER_TRIANGLE_HEIGHT;
    const left = visibleBtnRect.x + visibleBtnRect.width / 2;
    setWizardOffset({ top, left });
    setTimeout(ensureWizardInViewport, 0);
  };

  useEffect(() => {
    const userAgent = window.navigator.userAgent.toLowerCase();
    if (userAgent.match(/\b(android|kindle|silk)\b/)) {
      setRecoEbookType('mobi');
    }
  }, []);

  useEffect(positionWizard, [downloading, addingToCart, wrap.current]);

  useEffect(() => {
    window.addEventListener('resize', positionWizard);
    return () => window.removeEventListener('resize', positionWizard);
  }, [downloading, addingToCart]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    const escape: (e: KeyboardEvent) => any = ({ keyCode }) => {
      if (keyCode === 27 && (downloading || addingToCart)) {
        setDownloading(false);
        setAddingToCart(false);
      }
    };
    document.addEventListener('keydown', escape);
    return () => window.removeEventListener('keydown', escape);
  }, [downloading, addingToCart]);

  const addToCart = (editionType: EditionType): void => {
    const edition = editions.find(e => e.type === editionType);
    if (!edition) throw new Error(`Error selecting edition: ${editionType}`);
    store.cart.addItem(
      new CartItem({
        displayTitle: props.htmlShortTitle,
        title: edition.title,
        documentId: props.documentId,
        edition: edition.type,
        quantity: 1,
        printSize: edition.printSize,
        numPages: edition.numPages,
        author,
        interiorPdfUrl: edition.interiorPdfUrl,
        coverPdfUrl: edition.coverPdfUrl,
      }),
    );
  };

  return (
    <section
      ref={wrap}
      className="DocBlock relative bg-white pt-8 pb-12 px-10 md:px-12 lg:pb-24 xl:flex xl:flex-col xl:items-center"
    >
      {addingToCart && (
        <AddToCartWizard
          {...wizardOffset}
          editions={props.editions.map(e => e.type)}
          onSelect={editionType => {
            addToCart(editionType);
            setAddingToCart(false);
            setWizardOffset({ top: -9999, left: -9999 });
          }}
        />
      )}
      {downloading && (
        <DownloadWizard
          {...wizardOffset}
          eBookTypeRecommendation={recoEbookType}
          onSelect={(editionType, fileType) => {
            const edition = props.editions.find(e => e.type === editionType);
            if (edition) {
              setTimeout(() => {
                setDownloading(false);
                setWizardOffset({ top: -9999, left: -9999 });
              }, 4000);
              window.location.href = edition.downloadUrl[fileType];
            }
          }}
          editions={props.editions.map(e => e.type)}
        />
      )}
      <div className="TopWrap md:flex">
        <RotatableCover className="order-1" coverProps={{ ...props, pages: pages[0] }} />
        <div className="Text mb-8 md:px-12 bg-white md:mr-6 xl:mr-10">
          <h1
            className="font-sans text-3xl md:text-2-5xl font-bold leading-snug mt-8 tracking-wider mb-6"
            dangerouslySetInnerHTML={{ __html: props.htmlTitle }}
          />
          {!props.isCompilation && (
            <h2 className="font-sans text-1-5xl md:text-xl subpixel-antialiased leading-loose mb-8">
              <i className="font-serif tracking-widest pr-1">{t`by`}:</i>{' '}
              <Link className="strong-link" to={authorUrl}>
                {author}
              </Link>
            </h2>
          )}
          <p className="font-serif text-xl md:text-lg antialiased leading-relaxed">
            {description}
          </p>
          <LinksAndMeta
            className="hidden xl:block xl:mt-10"
            onClickAddToCart={() => {
              if (editions.length === 1) {
                return addToCart(editions[0].type);
              }
              setAddingToCart(!addingToCart);
              setDownloading(false);
            }}
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
        onClickAddToCart={() => {
          if (editions.length === 1) {
            return addToCart(editions[0].type);
          }
          setAddingToCart(!addingToCart);
          setDownloading(false);
        }}
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

function LinksAndMeta(
  props: Props & {
    className: string;
    onClickDownload: () => any;
    onClickAddToCart: () => any;
  },
): JSX.Element {
  const {
    price,
    hasAudio,
    size,
    author,
    edition,
    numChapters,
    pages,
    altLanguageUrl,
    className,
    onClickDownload,
    onClickAddToCart,
  } = props;
  return (
    <div className={className}>
      <DocActions
        download={onClickDownload}
        addToCart={onClickAddToCart}
        gotoAudio={makeScroller('#audiobook')}
        className="mb-8 flex flex-col md:flex-row items-center md:items-start lg:mx-24 xl:mx-0"
        price={price}
        hasAudio={hasAudio}
      />
      <div className="DocMeta flex flex-col items-center">
        <ul className="diamonds text-sans text-gray-600 leading-loose antialiased">
          <li>{author}</li>
          {LANG === 'en' && <li className="capitalize">{edition} Edition</li>}
          <li>{dimensions(size, pages)}</li>
          <li>{numChapters > 1 ? t`${numChapters} chapters` : t`1 chapter`}</li>
          <li>{pages.map(p => t`${p} pages`).join(', ')}</li>
          <li>
            <Dual.frag>
              <>Language: English</>
              <>Idioma: Español</>
            </Dual.frag>
          </li>
          {altLanguageUrl && (
            <li>
              <Dual.a href={altLanguageUrl}>
                <>Spanish Version</>
                <>Versión en inglés</>
              </Dual.a>
            </li>
          )}
        </ul>
      </div>
      <SpanishFreeBooksNote className="body-text mt-8 md:mt-10 sm:px-8 md:px-16 mx-auto max-w-screen-md opacity-75" />
    </div>
  );
}

function dimensions(size: PrintSize, pages: number[]): string {
  return (
    pages
      .map(p => bookDims(size, p))
      .map(dims =>
        [dims.width, dims.height, dims.depth]
          .map(n => (LANG === 'en' ? n : n * CENTIMETERS_IN_INCH))
          .map(n => n.toPrecision(2))
          .map(s => s.replace(/\.0+$/, ''))
          .join(' x '),
      )
      .join(', ') + `${LANG === 'en' ? ' in' : ' cm'}`
  );
}

function ensureWizardInViewport(): void {
  const wizard = document.querySelector('.ChoiceWizard');
  if (!wizard) {
    return;
  }

  const { bottom } = wizard.getBoundingClientRect();
  if (bottom > window.innerHeight) {
    const extraSpace = 25;
    const scrollTo = bottom - window.innerHeight + window.scrollY + extraSpace;
    window.scrollTo({ top: scrollTo, behavior: 'smooth' });
  }
}

const POPUNDER_TRIANGLE_HEIGHT = 16;
const CENTIMETERS_IN_INCH = 2.54;
