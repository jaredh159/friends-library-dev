import React from 'react';
import { useLocation } from 'react-router-dom';
import cx from 'classnames';
import { Link } from 'react-router-dom';
import { ChevronRightIcon } from '@heroicons/react/solid';

const Breadcrumbs: React.FC = ({}) => {
  const location = useLocation();
  const pathname = location.pathname.replace(/\/$/, ``);
  const parts: Array<[fullpath: string, segment: string]> = [];
  let fullpath = `/`;
  pathname.split(`/`).forEach((part, index) => {
    let segment = part === `` ? `home` : part;
    if (segment.match(MATCH_UUID)) {
      segment = (parts[index - 1]?.[1] ?? ``).replace(/s$/, ``);
    }
    parts.push([`${fullpath}${part}`, segment]);
    fullpath += part === `` ? `` : `${part}/`;
  });
  return (
    <ul className="flex text-[11px] mb-3">
      {parts.map(([path, segment], index) => (
        <li className="capitalize" key={path}>
          {index !== 0 && (
            <span className="px-[3px] text-flprimary opacity-60">
              <ChevronRightIcon className="inline w-[13px] h-[13px]" />
            </span>
          )}
          <Link
            to={path}
            className={cx(
              location.pathname !== path
                ? `border-b hover:border-solid hover:opacity-100`
                : `cursor-not-allowed`,
              `opacity-60 border-flprimary/50 border-dotted`,
            )}
          >
            {segment}
          </Link>
        </li>
      ))}
    </ul>
  );
};

export default Breadcrumbs;

const MATCH_UUID =
  /^[0-9A-F]{8}-[0-9A-F]{4}-4[0-9A-F]{3}-[89AB][0-9A-F]{3}-[0-9A-F]{12}$/i;
