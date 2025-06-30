import MainViewModel from '../viewmodel/MainViewModel';
import { HomeTopAppBar } from './HomeTopAppBar'
import { inputMethod } from '@kit.IMEKit';

@ComponentV2
export struct MainView {
  @Param mainViewModel: MainViewModel = new MainViewModel()

  @Builder
  ChatView() {
    Row() {
      TextArea({ text: this.mainViewModel.question, placeholder: $r('[common].string.enter_question') })
        .backgroundColor($r('[common].color.transparent'))
        .layoutWeight(1)
        .constraintSize({ maxHeight: 75 })
        .enterKeyType(EnterKeyType.Done)
        .onChange((value) => {
          this.mainViewModel.question = value
        })
        .onSubmit(() => {
          this.mainViewModel.sendData()
        })
      Button() {
        Image($r('[common].media.ic_send'))
          .fillColor($r('[common].color.icon_container'))
          .width(16)
          .height(16)
      }
      .backgroundColor($r('[common].color.icon'))
      .width(30)
      .height(30)
      .enabled(this.mainViewModel.question.trim().length > 0)
      .onClick(() => {
        inputMethod.getController().stopInputSession()
        this.mainViewModel.sendData()
      })
    }
    .alignItems(VerticalAlign.Bottom)
    .margin({ left: 12, right: 12, bottom: 12 })
    .padding({ right: 8, bottom: 8, top: 8 })
    .border({
      width: 1,
      color: $r('[common].color.outline_variant'),
      radius: 10,
    })
  }

  @Builder
  ChatList() {
    Column() {
      if (this.mainViewModel.answer.result) {
        Text(
          this.mainViewModel.answer.result.content
        )
        Text(
          this.mainViewModel.answer.result.reasoning_content
        )
      }
    }.layoutWeight(1)
  }

  build() {
    Column() {
      HomeTopAppBar({ toggleDrawer: this.mainViewModel.toggleDrawer })
      this.ChatList()
      this.ChatView()
    }
  }
}