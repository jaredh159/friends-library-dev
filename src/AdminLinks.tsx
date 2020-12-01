import React from 'react';
import cx from 'classnames';
import coverPropsMap from './cover-props';
import partTitlesMap from './part-titles';

const Link: React.FC<{
  path: string;
  to: string;
  className?: string;
  setPath: (path: string) => unknown;
}> = ({ path, to, className, children, setPath }) => (
  <a
    className={cx(
      className,
      `hover:underline font-bold admin-link`,
      path === to && `text-yellow-600 underline current antialiased`,
    )}
    href={to}
    onClick={(e) => {
      e.preventDefault();
      setPath(to);
    }}
  >
    {children}
  </a>
);

const AdminLinks: React.FC<{ current: string; setPath: (path: string) => unknown }> = ({
  current,
  setPath,
}) => {
  return (
    <div className="p-6">
      <h2 className="bold mb-2 text-xl text-white">Covers:</h2>
      <ul className="grid grid-cols-4 text-gray-400">
        {Object.entries(coverPropsMap).map(([editionPath, props]) => {
          const path = `/cover/${editionPath}`;
          return (
            <li key={path}>
              <Link to={path} path={current} setPath={setPath}>
                {props?.title}
              </Link>
            </li>
          );
        })}
      </ul>
      <h2 className="bold mt-6 mb-2 text-xl text-white">App Tease:</h2>
      <ul className="grid grid-cols-4 text-gray-400">
        {Object.entries(coverPropsMap).map(([editionPath, props]) => {
          const path = `/app-tease/${editionPath}`;
          return (
            <li key={path}>
              <Link to={path} path={current} setPath={setPath}>
                {props?.title}
              </Link>
            </li>
          );
        })}
      </ul>
      <h2 className="bold mt-6 mb-2 text-xl text-white">Static:</h2>
      <ul className="grid grid-cols-4 text-gray-400">
        <li>
          <Link to="/free-books/en" path={current} setPath={setPath}>
            Free books (English)
          </Link>
        </li>
        <li>
          <Link to="/free-books/es" path={current} setPath={setPath}>
            Free books (Spanish)
          </Link>
        </li>
        <li>
          <Link to="/continued/en" path={current} setPath={setPath}>
            Continued (English)
          </Link>
        </li>
        <li>
          <Link to="/continued/es" path={current} setPath={setPath}>
            Continued (Spanish)
          </Link>
        </li>
      </ul>
      <h2 className="bold mb-2 text-xl text-white mt-6">Part Titles:</h2>
      <ul className="grid grid-cols-4 text-gray-400">
        {Object.entries(partTitlesMap).map(([editionPath, titles]) => {
          const path = `/chapter/${editionPath}`;
          if (titles.length === 1) return null;
          return titles.map((title, idx) => {
            const partPath = `${path}/${idx}`;
            return (
              <li className="mb-3 leading-tight" key={partPath}>
                <Link to={partPath} path={current} setPath={setPath}>
                  {title}
                  <br />
                  <span className="opacity-50 pl-2">
                    &rarr; {editionPath.replace(/\/(updated|modernized)$/, ``)}:{idx + 1}
                  </span>
                </Link>
              </li>
            );
          });
        })}
      </ul>
    </div>
  );
};

export default AdminLinks;
