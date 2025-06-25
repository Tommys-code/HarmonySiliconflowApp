import { preferences } from "@kit.ArkData"

export const API_KET_FILE: string = "apiKey"

const API_KEY_NAME = "api_key"

class ApikeyStore {
  private static instance: ApikeyStore;
  store: preferences.Preferences

  private constructor() {
    this.store = preferences.getPreferencesSync(getContext(), { name: API_KET_FILE })
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

export const apikeyStore = ApikeyStore.getInstance()