import { ImageStyle } from "../extend/Image"
import { Style } from "../extend/Text"

@Builder
export function navigationTitle(title: string | Resource, onBack: () => void) {
  Stack({ alignContent: Alignment.Start }) {
    Text(title).attributeModifier(Style.TitleLarge)
      .width('100%').textAlign(TextAlign.Center)
      .padding({ left: 50, right: 50 })
    Image($r('app.media.ic_back'))
      .attributeModifier(ImageStyle.Medium)
      .onClick(onBack)
      .margin({ left: 12 })
  }.position({ x: 0 }).width('100%').height('100%')
}