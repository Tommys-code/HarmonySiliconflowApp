import { DeltaModel } from "common";

export abstract class ChatResource {
  public result: DeltaModel | null;

  constructor(result: DeltaModel | null) {
    this.result = result;
  }
}

export class Start extends ChatResource {
  public static readonly INSTANCE = new Start();

  constructor() {
    super(null);
  }
}

export class Progressing extends ChatResource {
  public data: DeltaModel;

  constructor(data: DeltaModel) {
    super(data);
    this.data = data;
  }
}

export class Finish extends ChatResource {
  public static readonly INSTANCE = new Finish();

  constructor() {
    super(null);
  }
}

export class Test extends ChatResource{
  public data: DeltaModel;
  constructor(data: DeltaModel) {
    super(data);
    this.data = data
  }
}

export type ChatResult = Start | Progressing | Finish | Test;