import { CommonDialog, NormalButton } from "common"
import { Session } from "common/src/main/ets/db/SessionDao"

@CustomDialog
export struct SessionDialog {
  controller: CustomDialogController
  @State options: SessionDialogInterface = { type: DialogType.EDIT_NAME }
  title: string | Resource = $r('[common].string.edit_session_name')
  @State content: string = ''
  editName?: (item: Session, name: string) => void
  delete?: (item: Session) => void
  batchDelete?: () => void

  aboutToAppear(): void {
    if (this.options.type === DialogType.EDIT_NAME) {
      this.title = $r('[common].string.edit_session_name')
      this.content = this.options.session?.title ?? ''
    } else {
      this.title = $r('[common].string.delete_dialog_title')
    }
  }

  @Builder
  contentBuilder() {
    if (this.options.type === DialogType.EDIT_NAME) {
      TextInput({
        text: this.content,
        placeholder: $r('[common].string.edit_session_name_tips')
      })
        .padding({
          left: 18,
          right: 18,
          top: 12,
          bottom: 12
        })
        .backgroundColor($r('[common].color.transparent'))
        .borderWidth(1)
        .borderColor($r('[common].color.outline_variant'))
        .borderRadius(12)
        .onChange((value: string) => {
          this.content = value
        })
    } else {
      this.textContentBuilder()
    }
  }

  @Builder
  textContentBuilder() {
    Text($r('[common].string.delete_session_tips'))
      .fontColor($r('[common].color.primary_text'))
      .textAlign(TextAlign.Center)
  }

  @Builder
  buttonBuilder() {
    NormalButton({
      text: $r('[common].string.cancel'),
      click: () => {
        this.controller.close()
      },
      weight: 1
    })
    if (this.options.type == DialogType.EDIT_NAME) {
      NormalButton({
        text: $r('[common].string.finish'),
        textColor: $r('[common].color.inverse_text'),
        color: $r('[common].color.inverse_background'),
        click: () => {
          if (this.options.session) {
            this.editName?.(this.options.session, this.content)
          }
          this.controller.close()
        },
        enable: this.editButtonEnable(),
        weight: 1
      })
    } else {
      NormalButton({
        text: $r('[common].string.confirm'),
        textColor: $r('[common].color.white'),
        color: $r('[common].color.highlight'),
        click: () => {
          if (this.options.session) {
            this.delete?.(this.options.session)
          } else if (this.options.type == DialogType.BATCH_DELETE) {
            this.batchDelete?.()
          }
          this.controller.close()
        },
        weight: 1
      })
    }
  }

  build() {
    CommonDialog({
      title: this.title,
      content: this.contentBuilder.bind(this),
      buttons: this.buttonBuilder.bind(this),
    })
  }

  editButtonEnable() {
    return this.content.trim().length > 0 && this.content != this.options.session?.title
  }
}

export enum DialogType {
  EDIT_NAME,
  DELETE,
  BATCH_DELETE,
}

export interface SessionDialogInterface {
  type: DialogType,
  session?: Session,
}
