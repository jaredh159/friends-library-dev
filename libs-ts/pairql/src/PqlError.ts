const TYPES = [`notFound`, `badRequest`, `serverError`, `unauthorized`, `other`];
type PqlErrorType = (typeof TYPES)[number];

export interface PqlError {
  id: string;
  requestId: string;
  type: PqlErrorType;
  detail?: string;
  statusCode: number;
}

export function isPqlError(input: unknown): input is PqlError {
  if (typeof input !== `object` || input === null) {
    return false;
  }
  const keys = [`id`, `requestId`, `type`, `statusCode`];
  for (const key of keys) {
    if (!(key in input)) {
      return false;
    }
  }

  const object: { [key: string]: unknown } = input as any;

  if (typeof object.id !== `string`) {
    return false;
  } else if (typeof object.requestId !== `string`) {
    return false;
  } else if (typeof object.type !== `string`) {
    return false;
  } else if (typeof object.statusCode !== `number`) {
    return false;
  }

  return TYPES.includes(object.type);
}
