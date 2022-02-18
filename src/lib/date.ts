import { Lang } from '@friends-library/types';
import { Document, Friend } from '../build/types';

export function documentDate(
  document: Pick<Document, 'published' | 'directoryPath'>,
  friend: Pick<Friend, 'born' | 'died' | 'isCompilations'>,
): number {
  const { born, died, isCompilations } = friend;
  if (document.published) {
    return document.published;
  }

  // the James Parnell case
  if (born && died && died - born < 31) {
    return died;
  }

  if (died && !born) {
    return died - 10;
  }

  if (born && died) {
    return Math.floor(born + 0.75 * (died - born));
  }

  if (!isCompilations) {
    throw new Error(
      `Unexpected failure to determine document date: ${document.directoryPath}`,
    );
  }

  // compilations don't need a date, this will cause them
  // to not show up on the /explore page timeline picker
  return -1;
}

export function periodFromDate(date: number): 'early' | 'mid' | 'late' {
  if (date <= 1720) {
    return `early`;
  }
  if (date <= 1810) {
    return `mid`;
  }
  return `late`;
}

export function published(
  dateStr: string,
  lang: Lang,
): { publishedTimestamp: number; publishedDate: string } {
  const date = new Date(dateStr);
  const formatter = new Intl.DateTimeFormat(`en-US`, { month: `short` });
  let month = formatter.format(date);
  if (lang === `es`) {
    month = spanishShortMonth(month);
  }
  return {
    publishedTimestamp: date.getTime(),
    publishedDate: `${month} ${date.getDate()}`,
  };
}

export function spanishShortMonth(short: string): string {
  switch (short.toLowerCase()) {
    case `jan`:
      return `Ene`;
    case `apr`:
      return `Abr`;
    case `aug`:
      return `Ago`;
    case `dec`:
      return `Dic`;
  }
  return short;
}
