import { CommonDialog, NormalButtonOptions } from 'common'

function createDeleteChatHistoryDialogButton(actions: MainDialogInterface) {
  return [
    new NormalButtonOptions().setText($r('[common].string.cancel'))
      .onClick(actions.action1),
    new NormalButtonOptions()
      .setText($r('[common].string.confirm'))
      .setTextColor($r('[common].color.white'))
      .setColor($r('[common].color.highlight'))
      .onClick(actions.action2)
  ]
}

@Builder
export function DeleteChatHistoryDialog(actions: MainDialogInterface) {
  CommonDialog({
    title: $r('[common].string.delete_dialog_title'),
    buttons: createDeleteChatHistoryDialogButton(actions),
    content: DeleteChatHistoryDialogContent,
  })
}

@Builder
function DeleteChatHistoryDialogContent() {
  Text($r('[common].string.delete_chat_tips'))
    .fontColor($r('[common].color.primary_text'))
    .textAlign(TextAlign.Center)
}

export interface MainDialogInterface {
  action1?: () => void
  action2?: () => void
}
