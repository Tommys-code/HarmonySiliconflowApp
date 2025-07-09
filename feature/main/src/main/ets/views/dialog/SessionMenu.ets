@Builder
export function SessionMenu(options: SessionMenuInterface) {
  if (!options.multiAble) {
    Column() {
      MenuItem({ content: $r('[common].string.mul_select') }).width('100%')
        .onClick(options.multiSelect)
      Divider().width('100%').strokeWidth(1).padding({ left: 4, right: 4 })
      MenuItem({ content: $r('[common].string.edit_session_name') }).width('100%')
        .onClick(options.editName)
      MenuItem({ content: $r('[common].string.delete') }).width('100%')
        .onClick(options.delete)
    }.width(120)
    .alignItems(HorizontalAlign.Start)
    .padding({ top: 4, bottom: 4 })
    .focusable(true)
  }
}


export interface SessionMenuInterface {
  multiAble: boolean
  multiSelect?: () => void,
  editName?: () => void,
  delete?: () => void,
}