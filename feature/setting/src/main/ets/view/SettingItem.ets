import { Style } from "common"

@Builder
export function SettingItem(options: SettingItemInterface) {
  Row() {
    Column() {
      Text(options.title).attributeModifier(Style.TitleMedium)
      if (options.desc) {
        Text(options.desc).attributeModifier(Style.LabelLarge)
          .fontColor($r('[common].color.secondary_text'))
          .margin({ top: 4 })
      }
    }.layoutWeight(1)
    .alignItems(HorizontalAlign.Start)

    if (options.isSelected) {
      Image($r('[common].media.ic_check'))
        .width(20)
        .height(20)
        .fillColor($r('[common].color.icon'))
    }
  }.width('100%')
  .padding({
    top: 18,
    bottom: 18,
    left: 12,
    right: 12
  }).onClick(options.onClick)
}

interface SettingItemInterface {
  title: Resource,
  desc?: Resource,
  onClick?: () => void,
  isSelected: boolean
}