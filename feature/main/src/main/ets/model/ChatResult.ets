export abstract class ChatResource<T> {
  public result: T | null;

  constructor(result: T | null) {
    this.result = result;
  }
}

export class Start extends ChatResource<null> {
  public static readonly INSTANCE = new Start();

  constructor() {
    super(null);
  }
}

export class Progress<T> extends ChatResource<T> {
  public data: T;

  constructor(data: T) {
    super(data);
    this.data = data;
  }
}

export class Finish extends ChatResource<null> {
  public static readonly INSTANCE = new Finish();

  constructor() {
    super(null);
  }
}

export type ChatResult<T> = Start | Progress<T> | Finish;