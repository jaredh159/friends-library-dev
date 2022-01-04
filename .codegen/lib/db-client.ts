import { File, DbClientProps } from './types';

export function repositories(files: File[]): string[] {
  const repos: string[] = [];
  for (const file of files) {
    const lines = file.source.split(`\n`);
    while (lines.length) {
      const line = lines.shift()!;
      const match = line.match(/^(?:struct|extension) ([^ :]+): LiveRepository {$/);
      if (match) {
        repos.push(match[1]);
      }
    }
  }
  return repos.sort((a, b) => (a.length < b.length ? -1 : 1));
}

export function extractClientProps(files: File[]): DbClientProps {
  for (const file of files) {
    const lines = file.source.split(`\n`);
    while (lines.length) {
      const line = lines.shift()!;
      if (line.startsWith(`struct DatabaseClient {`)) {
        return parseClientInner(lines);
      }
    }
  }
  throw new Error(`Failed to find DatabaseClient to extract from`);
}

function parseClientInner(lines: string[]): DbClientProps {
  const props: DbClientProps = [];
  while (lines.length) {
    let line = lines.shift()!;
    if (line === `}`) {
      return props;
    }

    // handle long declarations where swift-format breaks to two lines
    if (line.match(/  var ([^ :]+):$/)) {
      line += lines.shift()!;
    }

    const match = line.match(/  var ([^ :]+):\s+\(([^)]*)\)/);
    if (!match) {
      continue;
    }
    let numArgs = 0;
    if (match[2] !== ``) {
      numArgs = match[2].split(`,`).length;
    }
    props.push([match[1], numArgs]);
  }
  return props;
}
