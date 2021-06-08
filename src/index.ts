import { isDefined } from 'x-ts-utils';
import * as AWS from 'aws-sdk';
import env from '@friends-library/env';
import * as fs from 'fs';
import { extname } from 'path';

type LocalFilePath = string;
type CloudFilePath = string;

let clientInstance: AWS.S3 | null = null;

function getClient(): AWS.S3 {
  if (!clientInstance) {
    const { CLOUD_STORAGE_ENDPOINT, CLOUD_STORAGE_KEY, CLOUD_STORAGE_SECRET } =
      env.require(`CLOUD_STORAGE_ENDPOINT`, `CLOUD_STORAGE_KEY`, `CLOUD_STORAGE_SECRET`);
    clientInstance = new AWS.S3({
      httpOptions: { timeout: 1200000 }, // 20 minutes
      endpoint: new AWS.Endpoint(CLOUD_STORAGE_ENDPOINT).href,
      credentials: new AWS.Credentials({
        accessKeyId: CLOUD_STORAGE_KEY,
        secretAccessKey: CLOUD_STORAGE_SECRET,
      }),
    });
  }

  return clientInstance;
}

export function downloadFile(cloudFilePath: CloudFilePath): Promise<Buffer> {
  const { CLOUD_STORAGE_BUCKET } = env.require(`CLOUD_STORAGE_BUCKET`);
  const client = getClient();
  return new Promise((resolve, reject) => {
    client.getObject(
      {
        Bucket: CLOUD_STORAGE_BUCKET,
        Key: cloudFilePath,
      },
      (err, { Body }) => {
        if (err) {
          reject(err);
          return;
        }
        resolve(Body as Buffer);
      },
    );
  });
}

export async function metaData(cloudFilePath: CloudFilePath): Promise<{
  LastModified?: Date;
  ContentLength?: number;
  ETag?: string;
  ContentType?: string;
}> {
  const { CLOUD_STORAGE_BUCKET } = env.require(`CLOUD_STORAGE_BUCKET`);
  const client = getClient();
  return new Promise((resolve, reject) => {
    client.headObject(
      { Key: cloudFilePath, Bucket: CLOUD_STORAGE_BUCKET },
      (err, headData) => {
        if (err) {
          reject(err);
          return;
        }
        resolve(headData);
      },
    );
  });
}

export async function filesize(cloudFilePath: CloudFilePath): Promise<number | null> {
  try {
    const { ContentLength } = await metaData(cloudFilePath);
    return ContentLength || null;
  } catch (err) {
    return null;
  }
}

export async function md5File(cloudFilePath: CloudFilePath): Promise<string | null> {
  try {
    const { ETag } = await metaData(cloudFilePath);
    return ETag ? ETag.replace(/"/g, ``) : null;
  } catch (err) {
    return null;
  }
}

export async function uploadFile(
  localFilePath: LocalFilePath,
  cloudFilePath: CloudFilePath,
  opts: { delete: boolean } = { delete: false },
): Promise<string> {
  const { CLOUD_STORAGE_BUCKET_URL, CLOUD_STORAGE_BUCKET } = env.require(
    `CLOUD_STORAGE_BUCKET_URL`,
    `CLOUD_STORAGE_BUCKET`,
  );
  const client = getClient();
  return new Promise((resolve, reject) => {
    client.putObject(
      {
        Key: cloudFilePath,
        Body: fs.readFileSync(localFilePath),
        Bucket: CLOUD_STORAGE_BUCKET,
        ContentType: getContentType(localFilePath),
        ACL: `public-read`,
      },
      (err) => {
        if (err) {
          reject(err);
          return;
        }
        if (opts.delete) {
          fs.unlinkSync(localFilePath);
        }
        resolve(`${CLOUD_STORAGE_BUCKET_URL}/${cloudFilePath}`);
      },
    );
  });
}

export async function deleteFile(cloudFilePath: CloudFilePath): Promise<boolean> {
  const client = getClient();
  const BUCKET = env.requireVar(`CLOUD_STORAGE_BUCKET`);
  return new Promise((resolve, reject) => {
    client.deleteObject({ Bucket: BUCKET, Key: cloudFilePath }, (err) => {
      err ? reject(err) : resolve(true);
    });
  });
}

export async function uploadFiles(
  files: Map<LocalFilePath, CloudFilePath>,
  opts: { delete: boolean } = { delete: false },
): Promise<string[]> {
  const { CLOUD_STORAGE_BUCKET_URL } = env.require(`CLOUD_STORAGE_BUCKET_URL`);
  const promises = [...files].map(([localPath, cloudPath]) =>
    uploadFile(localPath, cloudPath, opts),
  );

  return Promise.all(promises).then(() => {
    return [...files.values()].map(
      (cloudPath) => `${CLOUD_STORAGE_BUCKET_URL}/${cloudPath}`,
    );
  });
}

export async function listObjects(prefix: CloudFilePath): Promise<CloudFilePath[]> {
  const client = getClient();
  return new Promise((resolve, reject) => {
    client.listObjects(
      {
        Bucket: env.requireVar(`CLOUD_STORAGE_BUCKET`),
        Prefix: prefix,
      },
      (listErr, listData) => {
        if (listErr) {
          reject(listErr);
          return;
        }
        resolve((listData.Contents || []).map(({ Key }) => Key).filter(isDefined));
      },
    );
  });
}

export async function rimraf(path: CloudFilePath): Promise<CloudFilePath[]> {
  const { CLOUD_STORAGE_BUCKET } = env.require(`CLOUD_STORAGE_BUCKET`);
  const client = getClient();
  // note, in `aws-sdk` v3 (now in alpha), it looks like they
  // switched to allowing `const data = await client.operation(...)`
  // so, should switch when released to avoid these shenanigans
  return new Promise((resolve, reject) => {
    client.listObjects(
      {
        Bucket: CLOUD_STORAGE_BUCKET,
        Prefix: path,
      },
      (listErr, listData) => {
        if (listErr) {
          reject(listErr);
          return;
        }
        client.deleteObjects(
          {
            Bucket: CLOUD_STORAGE_BUCKET,
            Delete: {
              Objects: (listData.Contents || [])
                .map(({ Key }) => Key)
                .filter(isDefined)
                .map((Key) => ({ Key })),
            },
          },
          (deleteErr, deleteData) => {
            if (deleteErr) {
              reject(deleteErr);
              return;
            }
            resolve((deleteData.Deleted || []).map(({ Key }) => Key).filter(isDefined));
          },
        );
      },
    );
  });
}

function getContentType(path: LocalFilePath): string {
  switch (extname(path)) {
    case `.mp3`:
      return `audio/mpeg`;
    case `.m4b`:
      return `audio/mp4`;
    case `.png`:
      return `image/png`;
    case `.pdf`:
      return `application/pdf`;
    case `.epub`:
      return `application/epub+zip`;
    case `.mobi`:
      return `application/x-mobipocket-ebook`;
    case `.zip`:
      return `application/zip`;
    case `.txt`:
      return `text/plain`;
    case `.html`:
      return `text/html`;
    case `.json`:
      return `application/json`;
    case `.css`:
      return `text/css`;
    default:
      throw new Error(`Unexpected file extension: ${path}`);
  }
}
