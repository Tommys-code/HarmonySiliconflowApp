import { MarkdownV2 } from "@lidary/markdown"
import { copyText, PromptActionClass, Style, ThreeDotLoading } from "common"
import { ChatHistory } from "common/src/main/ets/db/ChatHistoryDao"
import { ChatResult, Finish, Progressing, Start } from "../model/ChatResult"
import { ChatMenu, ChatMenuInterface } from "./dialog/ChatMenu"
import { ComponentContent } from "@kit.ArkUI"
import { DeleteChatHistoryDialog, MainDialogInterface } from "./dialog/MainDialog"
import MainViewModel from "../viewmodel/MainViewModel"

@ComponentV2
struct Send {
  @Param data: string = ''
  @Param chatMenuEvent?: ChatMenuInterface = undefined

  build() {
    Stack({ alignContent: Alignment.End }) {
      Text(this.data.trim())
        .borderRadius({ topLeft: 12, topRight: 12, bottomLeft: 12 })
        .padding({
          left: 20,
          right: 20,
          top: 8,
          bottom: 8
        })
        .margin({ bottom: 10 })
        .backgroundColor($r('[common].color.container'))
        .bindContextMenu(ChatMenu(this.chatMenuEvent), ResponseType.LongPress)
    }.width('100%')
  }
}

@ComponentV2
struct Thinking {
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
    }
    .height('auto')
    .margin({ bottom: 10 })
  }
}

@ComponentV2
struct Receive {
  @Param data: string = ''

  build() {
    MarkdownV2({
      content: this.data?.trim()
    }).width('100%')
      .margin({ bottom: 10 })
  }
}

@ComponentV2
export struct ChatItem {
  @Param data?: ChatHistory = undefined
  @Param mainViewModel: MainViewModel = new MainViewModel()
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.getUIContext(), wrapBuilder(DeleteChatHistoryDialog), {
      action1: this.hideDeleteDialog,
      action2: () => {
        if (this.data) {
          this.mainViewModel.deleteChatHistory(this.data).then((isSuccess) => {
            if (isSuccess) {
              this.showToast($r('[common].string.delete_success'))
            } else {
              this.showToast($r('[common].string.delete_error'))
            }
          })
        }
        this.hideDeleteDialog()
      }
    } as MainDialogInterface);

  aboutToAppear(): void {
    PromptActionClass.setContext(this.getUIContext());
    PromptActionClass.setContentNode(this.contentNode);
    PromptActionClass.setOptions({ alignment: DialogAlignment.Center, autoCancel: false });
  }

  private copy(text?: string): void {
    if (text) {
      copyText(text)
      this.showToast($r('[common].string.copy_success'))
    }
  }

  private showDeleteDialog(): void {
    PromptActionClass.openDialog()
  }

  private hideDeleteDialog(): void {
    PromptActionClass.closeDialog()
  }

  private showToast(msg: string | Resource) {
    this.getUIContext().getPromptAction().showToast({ message: msg })
  }

  build() {
    if (this.data) {
      Column() {
        if (this.data?.sendContent) {
          Send({
            data: this.data.sendContent, chatMenuEvent: {
              copy: () => this.copy(this.data?.sendContent),
              delete: () => this.showDeleteDialog(),
            }
          })
        }
        if (this.data.thinking) {
          Thinking({ data: this.data.thinking })
            .bindContextMenu(ChatMenu({
              copy: () => this.copy(this.data?.thinking),
              delete: () => this.showDeleteDialog(),
            }), ResponseType.LongPress)
        }
        if (this.data.receiveContent) {
          Receive({ data: this.data.receiveContent })
            .bindContextMenu(ChatMenu({
              copy: () => this.copy(this.data?.receiveContent),
              delete: () => this.showDeleteDialog(),
            }), ResponseType.LongPress)
        }
      }
    }
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
