import type { PqlError } from './PqlError';

export type ResultData<T> /* */ =
  | { type: 'success'; value: T }
  | { type: 'error'; error: PqlError };

export default class Result<T> {
  protected constructor(private data: ResultData<T>) {}

  public static success<T>(value: T): Result<T> {
    return new Result<T>({ type: `success`, value });
  }

  public static error(error: PqlError): Result<never> {
    return new Result<never>({ type: `error`, error });
  }

  public with(config: {
    success?: (value: T) => unknown;
    error?: (error: PqlError) => unknown;
  }): void {
    if (this.data.type === `success`) {
      config.success?.(this.data.value);
    } else {
      config.error?.(this.data.error);
    }
  }

  public valueOrThrow(): T {
    if (this.data.type === `success`) {
      return this.data.value;
    }
    throw this.data.error;
  }

  public get value(): T | undefined {
    if (this.data.type === `success`) {
      return this.data.value;
    }
    return undefined;
  }

  public get error(): PqlError | undefined {
    if (this.data.type === `error`) {
      return this.data.error;
    }
    return undefined;
  }

  public get isSuccess(): boolean {
    return this.data.type === `success`;
  }

  public get isError(): boolean {
    return this.data.type === `error`;
  }
}
