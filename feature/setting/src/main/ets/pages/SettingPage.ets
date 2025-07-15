import { navigationTitle, SFRoute, Style } from "common";

@ComponentV2
struct SettingPage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()

  @Builder
  itemBuilder(title: Resource, content: string | Resource, onClick: () => void) {
    Row() {
      Text(title).attributeModifier(Style.TitleMedium)
      Blank().layoutWeight(1)
      Text(content).fontColor($r('[common].color.tertiary_text'))
      Image($r('[common].media.ic_arrow_forward'))
        .width(12).height(12).margin({ left: 8 })
        .fillColor($r('[common].color.tertiary_text'))
    }.width('100%')
    .padding({
      top: 18,
      bottom: 18,
      left: 12,
      right: 12
    }).onClick(onClick)
  }

  build() {
    NavDestination() {
      Column() {
        Column() {
          this.itemBuilder($r('[common].string.setting_language'), '', () => {
            this.pageStack.pushPath({ name: SFRoute.LANGUAGE_SETTING_PAGE })
          })
          Divider().strokeWidth(0.5).margin({ left: 12, right: 12 })
          this.itemBuilder($r('[common].string.setting_theme'), '', () => {
            this.pageStack.pushPath({ name: SFRoute.THEME_PAGE })
          })
        }.margin({ top: 16, left: 18, right: 18 })
        .backgroundColor($r('[common].color.background_l1'))
        .borderRadius(12)
      }.width('100%')
      .height('100%')
    }
    .title(navigationTitle($r('[common].string.setting'), () => this.pageStack.pop()))
    .hideBackButton(true)
  }
}

@Builder
export function SettingPageBuilder() {
  SettingPage();
}