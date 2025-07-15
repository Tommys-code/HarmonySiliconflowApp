import { util } from "@kit.ArkTS";
import { AbilityContext } from "../utils/AbilityContext";
import { SettingDataStore } from "./SettingDataStore";

export interface TextAIModel {
  model: string,
  manu: string,
  max_tokens: number,
  enable_thinking?: boolean,
  desc: string,
}

export class ModelStore {
  private static instance: ModelStore;
  readonly modelList: TextAIModel[]
  private currentModel: TextAIModel

  private constructor() {
    const data = AbilityContext.getAbilityContext()
      .createModuleContext('common')
      .resourceManager
      .getRawFileContentSync('model.json')
    this.modelList = JSON.parse(this.uint8ArrayToString(data))
    this.currentModel =
      this.modelList.find((data) => data.model === SettingDataStore.getInstance().settingOptions.model) ??
      this.modelList[0]
  }

  private uint8ArrayToString(array: Uint8Array): string {
    let textDecoderOptions: util.TextDecoderOptions = {
      fatal: false,
      ignoreBOM: true
    }
    let decodeToStringOptions: util.DecodeToStringOptions = {
      stream: false
    }
    let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
    let retStr = textDecoder.decodeToString(array, decodeToStringOptions);
    return retStr;
  }

  getCurrentModel() {
    return this.currentModel
  }

  changeModel(model: TextAIModel) {
    SettingDataStore.getInstance().changeModel(model)
    this.currentModel = model
  }

  public static getInstance(): ModelStore {
    if (!ModelStore.instance) {
      ModelStore.instance = new ModelStore();
    }
    return ModelStore.instance;
  }
}