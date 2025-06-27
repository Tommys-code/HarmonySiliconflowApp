import { ComponentContent, PromptAction } from "@kit.ArkUI";

@Builder
function buildLoadingComponent() {
  Stack() {
    LoadingProgress()
      .width(100)
      .color($r('app.color.background_l1'))
  }.backgroundColor($r('app.color.inverse_background_half_trans'))
  .borderRadius(12)
  .width(160)
  .height(160)
}

export class LoadingDialog {
  static component?: ComponentContent<object>
  static promptAction?: PromptAction

  static show(context: UIContext) {
    if (LoadingDialog.component) {
      return;
    }
    const componentContent = new ComponentContent(context, wrapBuilder(buildLoadingComponent))
    const prompt = context.getPromptAction()
    prompt.openCustomDialog(
      componentContent,
      {
        autoCancel: false,
        onWillDismiss: (dismissDialogAction) => {
          if (dismissDialogAction.reason === DismissReason.PRESS_BACK) {
            true
          }
        }
      }
    ).then(() => {
      LoadingDialog.component = componentContent
      LoadingDialog.promptAction = prompt
    })
  }

  static dismiss() {
    if (LoadingDialog.component && LoadingDialog.promptAction) {
      LoadingDialog.promptAction.closeCustomDialog(LoadingDialog.component).finally(() => {
        LoadingDialog.component = undefined
        LoadingDialog.promptAction = undefined
      })
    }
  }
}
