import { Language, navigationTitle, SettingDataStore, SettingOptions, Style } from 'common'
import { SettingItem } from '../view/SettingItem'

@ComponentV2
struct LanguageSettingPage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()
  @Local language: Language = SettingDataStore.getInstance().settingOptions.language

  build() {
    NavDestination() {
      Stack() {
        Column() {
          SettingItem({
            title: $r('[common].string.language_default'),
            desc: $r('[common].string.language_default_tips'),
            isSelected: this.language === Language.SYSTEM,
            onClick: () => {
              this.changeLanguage(Language.SYSTEM)
            }
          })
          Divider().strokeWidth(0.5).margin({ left: 12, right: 12 })
          SettingItem({
            title: $r('[common].string.language_zh'),
            isSelected: this.language === Language.CHINESE,
            onClick: () => {
              this.changeLanguage(Language.CHINESE)
            }
          })
          Divider().strokeWidth(0.5).margin({ left: 12, right: 12 })
          SettingItem({
            title: $r('[common].string.language_en'),
            isSelected: this.language === Language.ENGLISH,
            onClick: () => {
              this.changeLanguage(Language.ENGLISH)
            }
          })
        }.borderRadius(12)
        .width('100%')
        .backgroundColor($r('[common].color.background_l1'))
      }.padding({ top: 16, left: 18, right: 18 })
    }
    .title(navigationTitle($r('[common].string.setting_theme'), () => this.pageStack.pop()))
    .hideBackButton(true)
  }

  changeLanguage(language: Language) {
    SettingDataStore.getInstance().changeLanguage(language)
    this.language = language
  }
}

@Builder
export function LanguageSettingPageBuilder() {
  LanguageSettingPage();
}