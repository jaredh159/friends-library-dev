import fs from 'fs';
import dotenv from 'dotenv';

const SYMLINKED_PATH = `${__dirname}/../../../.env`;
const LOCAL_INSTALL_PATH = `${__dirname}/../../../../../../.env`;

if (!process.env.CI) {
  if (fs.existsSync(SYMLINKED_PATH)) {
    dotenv.config({ path: SYMLINKED_PATH });
  } else if (fs.existsSync(LOCAL_INSTALL_PATH)) {
    dotenv.config({ path: LOCAL_INSTALL_PATH });
  }
}
