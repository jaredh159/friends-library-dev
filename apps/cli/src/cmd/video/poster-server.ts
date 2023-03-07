import puppeteer from 'puppeteer';
import env from '@friends-library/env';

export interface ScreenshotTaker {
  (path: string): Promise<Buffer>;
}

interface BrowserCloser {
  (): Promise<void>;
}

export async function screenshot(
  port: number,
): Promise<[ScreenshotTaker, BrowserCloser]> {
  const { CHROMIUM_PATH } = env.require(`CHROMIUM_PATH`);
  // if you get error launching, try `unset PUPPETEER_PRODUCT`
  const browser = await puppeteer.launch({ executablePath: CHROMIUM_PATH });
  const page = await browser.newPage();
  await page.setViewport({ width: 1920, height: 1080 });

  return [
    async (path: string): Promise<Buffer> => {
      await page.goto(`http://localhost:${port}/${path}`);
      return page.screenshot({
        encoding: `binary`,
        clip: { x: 0, y: 0, width: 1920, height: 1080 },
      }) as Promise<Buffer>;
    },
    async () => await browser.close(),
  ];
}
