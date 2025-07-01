import { preferences } from '@kit.ArkData'

export const SETTING_STORE_FILE: string = "setting"

const API_KEY_NAME = "api_key"

class SettingDataStore {
  store: preferences.Preferences

  constructor() {
    this.store = preferences.getPreferencesSync(getContext(), { name: SETTING_STORE_FILE })
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
}