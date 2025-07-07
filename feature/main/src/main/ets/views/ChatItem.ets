import { MarkdownV2 } from "@lidary/markdown"
import { Style, ThreeDotLoading } from "common"
import { ChatResult, Finish, Progressing, Start } from "../model/ChatResult"

@ComponentV2
export struct Thinking {
  @Param data: string = ''

  build() {
    RelativeContainer() {
      Divider()
        .vertical(true)
        .strokeWidth(2)
        .alignRules({
          top: { anchor: 'content', align: VerticalAlign.Top },
          bottom: { anchor: 'content', align: VerticalAlign.Bottom }
        })
        .id('Divider')
      MarkdownV2({
        content: this.data?.trim(),
        fontStyle: {
          fontColor: $r('[common].color.secondary_text'),
          fontSize: Style.BodyMediumSize
        }
      })
        .width('100%')
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .padding({ left: 10 })
        .id('content')
    }.height('auto')
    .margin({ bottom: 10 })
  }
}

@ComponentV2
export struct Receive {
  @Param data: string = ''

  build() {
    MarkdownV2({
      content: this.data?.trim()
    }).width('100%')
      .margin({ bottom: 10 })
  }
}

@ComponentV2
export struct Answer {
  @Param data: ChatResult = Finish.INSTANCE

  build() {
    if (this.data instanceof Start) {
      ThreeDotLoading().margin({ bottom: 10 })
    } else if (this.data instanceof Progressing) {
      Column() {
        Thinking({ data: this.data.data.reasoning_content })
        Receive({ data: this.data.data.content })
      }
    }
  }
}