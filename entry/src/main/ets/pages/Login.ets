import { Style } from 'common';

@Entry
@Component
struct Login {
  @State enable: boolean = false;

  build() {
    RelativeContainer() {
      Column() {
        Image($r('app.media.ic_silicon_flow'))
          .height(60)
          .objectFit(ImageFit.Cover)
        Text($r('app.string.add_key_title'))
          .attributeModifier(Style.TitleLarge)
          .margin({ top: 8, bottom: 8 })
        TextInput({ placeholder: $r('app.string.add_key_hilt') })
          .backgroundColor($r('[common].color.background_l1'))
          .onChange((value: string) => {
            this.enable = value.trim().length > 0
          })
          .borderRadius(2)
          .height(48)
          .width('100%')
          .margin({
            left: 18,
            right: 18,
            top: 10,
            bottom: 10,
          })
        Button($r('[common].string.confirm'))
          .type(ButtonType.Normal)
          .borderRadius(0)
          .enabled(this.enable)
          .width('100%')
          .height(48)
          .margin({
            left: 18,
            right: 18,
            top: 10,
            bottom: 10,
          })
          .onClick(() => {

          })
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
      .width('80%')
    }
    .height('100%')
    .width('100%')
  }
}