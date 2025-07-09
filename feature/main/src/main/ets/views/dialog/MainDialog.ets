import { CommonDialog, NormalButton } from 'common'

@CustomDialog
export struct DeleteChatHistoryDialog2 {
  controller: CustomDialogController
  delete?: () => void

  @Builder
  deleteChatHistoryDialogContent() {
    Text($r('[common].string.delete_chat_tips'))
      .fontColor($r('[common].color.primary_text'))
      .textAlign(TextAlign.Center)
  }

  @Builder
  deleteChatHistoryDialogButton() {
    NormalButton({
      text: $r('[common].string.cancel'),
      click: () => {
        this.controller.close()
      }
    })
    NormalButton({
      text: $r('[common].string.confirm'),
      textColor: $r('[common].color.white'),
      color: $r('[common].color.highlight'),
      click: () => {
        this.controller.close()
        if (this.delete) {
          this.delete()
        }
      }
    })
  }

  build() {
    CommonDialog({
      title: $r('[common].string.delete_dialog_title'),
      content: this.deleteChatHistoryDialogContent.bind(this),
      buttons: this.deleteChatHistoryDialogButton.bind(this),
    })
  }
}
