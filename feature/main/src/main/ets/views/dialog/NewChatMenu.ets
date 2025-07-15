import { MyMenu } from "./ChatMenu"

@Builder
export function NewChatMenu(option?: NewChatMenuInterface) {
  Column() {
    MyMenu($r('[common].media.ic_chat'), $r('[common].string.create_new_session'), option?.newChat)
    Divider().width('100%').strokeWidth(0.5)
    MyMenu($r('[common].media.ic_image'), $r('[common].string.create_new_image'), option?.newImageCreation)
  }.width(120)
  .alignItems(HorizontalAlign.Start)
  .padding({ top: 4, bottom: 4 })
}

export interface NewChatMenuInterface {
  newChat?: () => void,
  newImageCreation?: () => void,
}