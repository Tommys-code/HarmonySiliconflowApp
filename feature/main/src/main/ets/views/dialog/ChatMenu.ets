import { ImageStyle } from "common"

@Builder
export function ChatMenu(item?: ChatMenuInterface) {
  Column() {
    MyMenu($r('[common].media.ic_content_copy'), $r('[common].string.copy'), item?.copy)
    Divider().width('100%').strokeWidth(0.5)
    MyMenu($r('[common].media.ic_delete'), $r('[common].string.delete'), item?.delete)
  }.width(120)
  .alignItems(HorizontalAlign.Start)
  .padding({ top: 4, bottom: 4 })
}

@Builder
export function MyMenu(image: ResourceStr, text: ResourceStr, event?: (event: ClickEvent) => void) {
  Row() {
    Image(image).attributeModifier(ImageStyle.Small)
      .margin({ right: 10 })
    Text(text)
  }
  .width('100%')
  .padding({
    left: 8,
    right: 8,
    top: 8,
    bottom: 8
  }).onClick(event)
}

export interface ChatMenuInterface {
  copy?: () => void,
  delete?: () => void,
}