import { ImageStyle, Style } from "common"

@ComponentV2
export struct ImageConfigView {
  @Param content: string | Resource = ''

  build() {
    Row() {
      Text(this.content)
        .fontColor($r('[common].color.primary_text'))
        .attributeModifier(Style.BodyMedium)
      Image($r('[common].media.ic_keyboard_arrow_down'))
        .attributeModifier(ImageStyle.Tiny)
        .fillColor($r('[common].color.primary_text'))
    }.borderRadius(10)
    .borderWidth(0.5)
    .borderColor($r('[common].color.outline_variant'))
    .padding({
      left: 12,
      right: 12,
      top: 8,
      bottom: 8,
    })
  }
}