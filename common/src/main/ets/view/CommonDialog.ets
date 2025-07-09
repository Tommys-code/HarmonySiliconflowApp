import { Style } from "../extend/Text"
import { NormalButton, NormalButtonOptions } from "./NormalButton";

@ComponentV2
export struct CommonDialog {
  @Param title: string | Resource = '';
  @Param buttons: NormalButtonOptions[] = []
  @BuilderParam content: () => void;

  build() {
    Column() {
      Text(this.title)
        .fontWeight(FontWeight.Bold)
        .attributeModifier(Style.TitleLarge)
        .fontColor($r('app.color.primary_text'))
        .padding({ top: 12, bottom: 12 })
      this.content()
      Row({ space: 12 }) {
        ForEach(this.buttons, (options: NormalButtonOptions) => {
          NormalButton({ buttonOptions: options }).layoutWeight(1)
        })
      }.width('100%')
      .padding({ top: 16, bottom: 16 })
    }.padding({ left: 16, right: 16 })
    .borderRadius(12)
    .backgroundColor($r('app.color.pop_container'))
    .width('80%')
  }
}
