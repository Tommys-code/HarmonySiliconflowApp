import { preferences } from '@kit.ArkData'
import { AbilityContext } from '../utils/AbilityContext';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { i18n } from '@kit.LocalizationKit';
import { TextAIModel } from '../../../../Index';

export const SETTING_STORE_FILE: string = "setting"

const FOLLOW_SYSTEM_THEME = 'follow_system_theme'
const DARK_MODE = "dark_mode"
const LANGUAGE_KEY = "language"

const MODEL_KEY = 'model'
const DEFAULT_MODEL = "Qwen/Qwen3-8B"

export class SettingDataStore {
  private static instance: SettingDataStore;
  private store: preferences.Preferences
  readonly settingOptions: SettingOptions

  private constructor() {
    this.store = preferences.getPreferencesSync(AbilityContext.getAbilityContext(), { name: SETTING_STORE_FILE })
    const textModel = this.store.getSync(MODEL_KEY, DEFAULT_MODEL) as string
    const useSystemTheme = this.store.getSync(FOLLOW_SYSTEM_THEME, true) as boolean
    const isDarkMode = this.store.getSync(DARK_MODE, false) as boolean
    const language = this.store.getSync(LANGUAGE_KEY, Language.SYSTEM) as Language
    this.settingOptions = {
      useSystemTheme: useSystemTheme,
      isDarkMode: isDarkMode,
      language: language,
      model: textModel
    }
  }

  init() {
    AbilityContext.getAbilityContext().getApplicationContext().setColorMode(getColorMode(this.settingOptions))
    AbilityContext.getAbilityContext().getApplicationContext().setLanguage(getLanguage(this.settingOptions))
  }

  changeTheme(isDark?: boolean) {
    if (isDark != undefined) {
      this.store.put(DARK_MODE, isDark)
      this.store.flush()
      this.settingOptions.isDarkMode = isDark
      AbilityContext.getAbilityContext().getApplicationContext().setColorMode(getColorMode(this.settingOptions))
    } else {
      const useSystemTheme = !this.settingOptions.useSystemTheme
      this.store.put(FOLLOW_SYSTEM_THEME, useSystemTheme)
      this.store.flush()
      this.settingOptions.useSystemTheme = useSystemTheme
      AbilityContext.getAbilityContext().getApplicationContext().setColorMode(getColorMode(this.settingOptions))
    }
  }

  changeLanguage(language: Language) {
    if (language !== this.settingOptions.language) {
      this.store.put(LANGUAGE_KEY, language)
      this.store.flush()
      this.settingOptions.language = language
      AbilityContext.getAbilityContext().getApplicationContext().setLanguage(getLanguage(this.settingOptions))
    }
  }

  changeModel(model: TextAIModel) {
    if (model.model !== this.settingOptions.model) {
      this.store.put(MODEL_KEY, model.model)
      this.store.flush()
      this.settingOptions.model = model.model
    }
  }

  public static getInstance(): SettingDataStore {
    if (!SettingDataStore.instance) {
      SettingDataStore.instance = new SettingDataStore();
    }
    return SettingDataStore.instance;
  }
}

export interface SettingOptions {
  useSystemTheme: boolean
  isDarkMode: boolean
  language: Language
  model: string
}

export enum Language {
  SYSTEM = 'default',
  CHINESE = 'zh',
  ENGLISH = 'en',
}

function getColorMode(settingOptions: SettingOptions) {
  return settingOptions.useSystemTheme
    ? ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET
    : (settingOptions.isDarkMode
      ? ConfigurationConstant.ColorMode.COLOR_MODE_DARK
      : ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
}

function getLanguage(settingOptions: SettingOptions): string {
  if (settingOptions.language === Language.SYSTEM) {
    return i18n.System.getSystemLanguage()
  } else {
    return settingOptions.language
  }
}
