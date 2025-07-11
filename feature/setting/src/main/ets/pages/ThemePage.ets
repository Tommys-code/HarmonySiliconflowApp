import { navigationTitle, SettingDataStore, Style } from 'common'
import { SettingItem } from '../view/SettingItem'

@ComponentV2
struct ThemePage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()
  @Local useSystemTheme: boolean = SettingDataStore.getInstance().settingOptions.useSystemTheme
  @Local isDarkMode: boolean = SettingDataStore.getInstance().settingOptions.isDarkMode

  @Monitor('useSystemTheme')
  systemThemeChange() {
    SettingDataStore.getInstance().changeTheme()
  }

  @Builder
  systemItem() {
    Column() {
      Row() {
        Text($r('[common].string.language_default'))
          .attributeModifier(Style.TitleMedium)
          .textAlign(TextAlign.Start).layoutWeight(1)
        Toggle({ type: ToggleType.Switch, isOn: $$this.useSystemTheme })
          .height(30)
          .width(60)
      }

      Text($r('[common].string.theme_default_tips'))
        .attributeModifier(Style.LabelLarge)
        .fontColor($r('[common].color.secondary_text'))
        .margin({ top: 4 })
        .width('100%')
        .textAlign(TextAlign.Start)
    }
    .width('100%')
    .height('auto')
    .borderRadius(12)
    .padding({
      left: 12,
      right: 12,
      top: 8,
      bottom: 18
    })
    .backgroundColor($r('[common].color.background_l1'))
  }

  build() {
    NavDestination() {
      Column() {
        this.systemItem()

        if (!this.useSystemTheme) {
          Text($r('[common].string.setting_manual'))
            .margin({ top: 16, bottom: 8 })
            .attributeModifier(Style.BodyMedium)
          Column() {
            SettingItem({
              title: $r('[common].string.light_theme'),
              isSelected: !this.isDarkMode,
              onClick: () => {
                this.changeTheme(false)
              }
            })

            Divider().strokeWidth(0.5).margin({ left: 12, right: 12 })
            SettingItem({
              title: $r('[common].string.dark_theme'),
              isSelected: this.isDarkMode,
              onClick: () => {
                this.changeTheme(true)
              }
            })
          }.borderRadius(12)
          .width('100%')
          .backgroundColor($r('[common].color.background_l1'))
        }
      }.padding({ top: 16, left: 18, right: 18 })
      .width('100%')
      .alignItems(HorizontalAlign.Start)
    }
    .title(navigationTitle($r('[common].string.setting_theme'), () => this.pageStack.pop()))
    .hideBackButton(true)
  }

  changeTheme(isDark: boolean) {
    if (isDark != this.isDarkMode) {
      this.isDarkMode = isDark
      SettingDataStore.getInstance().changeTheme(isDark)
    }
  }
}

@Builder
export function ThemePageBuilder() {
  ThemePage();
}