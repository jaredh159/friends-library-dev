import React, { useState, useEffect } from 'react';
import CoverGeneral from './CoverGeneral';
import FreeBooks from './FreeBooks';
import AppTease from './AppTease';
import Chapter from './Chapter';
import AdminLinks from './AdminLinks';
import Continued from './Continued';
import './App.css';

const App: React.FC = () => {
  const [path, setPathState] = useState(window.location.pathname);

  const setPath: (nextPath: string) => void = (nextPath) => {
    window.history.pushState({}, ``, nextPath);
    setPathState(nextPath);
  };

  useEffect(() => {
    const listener: (e: KeyboardEvent) => any = (e) => {
      if (![`ArrowRight`, `ArrowLeft`].includes(e.key)) {
        return;
      }
      e.preventDefault();
      const allLinks = document.querySelectorAll(`.admin-link`);
      const selected = document.querySelector(`.admin-link.current`);
      allLinks.forEach((link, idx) => {
        if (link !== selected) {
          return;
        }
        let nextIdx = -1;
        if (e.key === `ArrowRight`) {
          nextIdx = idx === allLinks.length - 1 ? 0 : idx + 1;
        } else {
          nextIdx = idx === 0 ? allLinks.length - 1 : idx - 1;
        }
        const nextPath = allLinks[nextIdx]?.getAttribute(`href`) || ``;
        setPath(nextPath);
      });
    };
    document.addEventListener(`keydown`, listener);
    return () => {
      document.removeEventListener(`keydown`, listener);
    };
  });

  let poster: JSX.Element | null = null;
  if (path.startsWith(`/cover/`)) {
    const editionPath = path.replace(/^\/cover\//, ``);
    const params = new URLSearchParams(window.location.search);
    const numVols = params.has(`vols`) ? Number(params.get(`vols`)) : 1;
    const volNum = params.has(`vol`) ? Number(params.get(`vol`)) : 1;
    poster = <CoverGeneral editionPath={editionPath} numVols={numVols} volNum={volNum} />;
  }

  if (path.startsWith(`/continued/`)) {
    const lang = path.endsWith(`/es`) ? `es` : `en`;
    poster = <Continued lang={lang} />;
  }

  if (path.startsWith(`/app-tease/`)) {
    const editionPath = path.replace(/^\/app-tease\//, ``);
    const lang = path.includes(`/es/`) ? `es` : `en`;
    poster = <AppTease lang={lang} editionPath={editionPath} />;
  }

  if (path.startsWith(`/chapter/`)) {
    const lang = path.includes(`/es/`) ? `es` : `en`;
    let partIdx = -1;
    const editionPath = path.replace(/^\/chapter\//, ``).replace(/\/(\d+)$/, (_, num) => {
      partIdx = Number(num);
      return ``;
    });
    if (partIdx < 0 || Number.isNaN(partIdx)) {
      throw new Error(`bad part num from url: ${window.location.pathname}`);
    }
    poster = <Chapter lang={lang} editionPath={editionPath} partIdx={partIdx} />;
  }

  if (path.startsWith(`/free-books/`)) {
    const lang = path.endsWith(`/es`) ? `es` : `en`;
    poster = <FreeBooks lang={lang} />;
  }

  if (poster === null) {
    setTimeout(() => (window.location.href = `/free-books/en`), 5000);
    return (
      <h1 style={{ textAlign: `center`, fontSize: 40, color: `white`, padding: `3em` }}>
        Unknown path. Redirecting...
      </h1>
    );
  }

  return (
    <>
      {poster}
      <AdminLinks current={path} setPath={setPath} />
    </>
  );
};

export default App;
