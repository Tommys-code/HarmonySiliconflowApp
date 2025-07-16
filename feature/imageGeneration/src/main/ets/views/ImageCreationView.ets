import { ImageCreationViewModel } from "../viewmodel/ImageCreationViewModel"
import { inputMethod } from "@kit.IMEKit"
import { ImageConfigView } from "./ImageConfigView"

@ComponentV2
export struct ImageCreationView {
  @Param viewModel: ImageCreationViewModel = new ImageCreationViewModel()

  private sendData() {
    inputMethod.getController().stopInputSession()
    this.viewModel.createImage()
  }

  build() {
    Column() {
      // Row() {
      //   ImageConfigView({ content: $r('[common].string.ratio') })
      // }
      Row() {
        TextArea({ text: this.viewModel.prompt, placeholder: $r('[common].string.image_creation_hilt') })
          .backgroundColor($r('[common].color.transparent'))
          .layoutWeight(1)
          .constraintSize({ maxHeight: 75 })
          .enterKeyType(EnterKeyType.Done)
          .onChange((value) => {
            this.viewModel.prompt = value
          })
          .onSubmit(() => this.sendData())
        Button() {
          Image($r('[common].media.ic_send'))
            .fillColor($r('[common].color.icon_container'))
            .width(16)
            .height(16)
        }
        .backgroundColor($r('[common].color.icon'))
        .width(30)
        .height(30)
        .enabled(this.viewModel.prompt.trim().length > 0)
        .onClick(() => this.sendData())
      }
    }
    .padding({ right: 8, bottom: 8, top: 8 })
    .border({
      width: 1,
      color: $r('[common].color.outline_variant'),
      radius: 10,
    })
  }
}