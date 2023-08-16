import type { DownloadType } from '@/components/pages/document/DownloadWizard';

export function downloadUrl(
  format: DownloadType,
  editionId: string,
  referer: string,
): string {
  return `https://api.friendslibrary.com/download/${editionId}/ebook/${
    format === `web_pdf` ? `pdf` : format
  }?referer=${referer}`;
}
