import { Style } from "../extend/Text"

@Builder
export function navigationTitle(title: string | Resource, onBack: () => void) {
  Stack({ alignContent: Alignment.Start }) {
    Text(title).attributeModifier(Style.TitleLarge)
      .width('100%').textAlign(TextAlign.Center)
      .padding({ left: 50, right: 50 })
    Image($r('app.media.ic_back'))
      .fillColor($r('app.color.icon'))
      .height(32)
      .width(32)
      .onClick(onBack)
      .margin({ left: 12 })
  }.position({ x: 0 }).width('100%').height('100%')
}