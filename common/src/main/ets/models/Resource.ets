abstract class Resource<T> {
  public result: T | null;

  constructor(result: T | null) {
    this.result = result;
  }
}

export class Loading extends Resource<null> {
  static Progress = new Loading(true)
  public loading: boolean;

  constructor(loading: boolean = false) {
    super(null);
    this.loading = loading;
  }
}

export class Success<T> extends Resource<T> {
  public data: T;

  constructor(data: T) {
    super(data);
    this.data = data;
  }
}

export class Failed extends Resource<null> {
  public exception: Error;

  constructor(exception: Error) {
    super(null);
    this.exception = exception;
  }
}

export type ResourceType<T> = Loading | Success<T> | Failed;