import { preferences } from "@kit.ArkData"
import { AbilityContext } from "../utils/AbilityContext";
import { hilog } from "@kit.PerformanceAnalysisKit";

export const API_KET_FILE: string = "apiKey"

const API_KEY_NAME = "api_key"

export class ApikeyStore {
  private static instance: ApikeyStore;
  store: preferences.Preferences

  private constructor() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'ApikeyStore');
    this.store = preferences.getPreferencesSync(AbilityContext.getAbilityContext(), { name: API_KET_FILE })
    const apiKey = this.store.getSync(API_KEY_NAME, null)
    if (apiKey) {
      AppStorage.setOrCreate(API_KEY_NAME, apiKey)
    }
  }

  getApiKey() {
    return AppStorage.get<string>(API_KEY_NAME)
  }

  async saveApiKey(key: string) {
    AppStorage.setOrCreate(API_KEY_NAME, key)
    await this.store.put(API_KEY_NAME, key)
    await this.store.flush()
  }

  public static getInstance(): ApikeyStore {
    if (!ApikeyStore.instance) {
      ApikeyStore.instance = new ApikeyStore();
    }
    return ApikeyStore.instance;
  }
}