import type { DownloadType } from '@/components/pages/document/DownloadWizard';

export function downloadUrl(
  format: DownloadType,
  editionId: string,
  referer: string,
): string {
  // TODO(@jaredh159): only use prod api url in production
  return `https://api.friendslibrary.com/download/${editionId}/ebook/${
    format === `web_pdf` ? `pdf` : format
  }?referer=${referer}`;
}
