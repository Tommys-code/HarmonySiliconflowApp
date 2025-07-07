import MainViewModel from '../viewmodel/MainViewModel';
import { HomeTopAppBar } from './HomeTopAppBar'
import { inputMethod } from '@kit.IMEKit';
import { ChatHistory, getChatHistoryKey } from 'common/src/main/ets/db/ChatHistoryDao';
import { ListDataSourceDataChange } from 'common';
import { Answer, Receive, Thinking } from './ChatItem';

@ComponentV2
export struct MainView {
  @Param mainViewModel: MainViewModel = new MainViewModel()
  private dataChangeListener = new ListDataSourceDataChange(() => {
    this.chatHistoryChange()
  })
  private scroller: Scroller = new Scroller()

  // @Monitor('mainViewModel.answer')
  // onAnswerChange() {
  //   this.chatHistoryChange
  // }

  aboutToAppear(): void {
    this.mainViewModel.chatHistory.registerDataChangeListener(this.dataChangeListener)
  }

  aboutToDisappear(): void {
    this.mainViewModel.chatHistory.unregisterDataChangeListener(this.dataChangeListener)
    this.mainViewModel.onCleared()
  }

  chatHistoryChange() {
    this.scroller.scrollEdge(Edge.Bottom)
  }

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
    List({ scroller: this.scroller }) {
      LazyForEach(this.mainViewModel.chatHistory, (item: ChatHistory) => {
        ListItem() {
          Column() {
            if (item.sendContent) {
              this.SendChat(item.sendContent)
            }
            Thinking({ data: item.thinking })
            Receive({ data: item.receiveContent })
          }
        }
      }, (item: ChatHistory) => getChatHistoryKey(item))
      ListItem() {
        Answer({ data: this.mainViewModel.answer })
      }
    }.layoutWeight(1)
    .padding({ left: 16, right: 16 })
    .scrollBar(BarState.Off)
    .width('100%')
  }

  @Builder
  SendChat(text: string) {
    Stack({ alignContent: Alignment.End }) {
      Text(text)
        .borderRadius({ topLeft: 12, topRight: 12, bottomLeft: 12 })
        .padding({
          left: 20,
          right: 20,
          top: 8,
          bottom: 8
        })
        .margin({ bottom: 10 })
        .backgroundColor($r('[common].color.container'))
    }.width('100%')
  }

  build() {
    Column() {
      HomeTopAppBar({ toggleDrawer: this.mainViewModel.toggleDrawer })
      this.ChatList()
      this.ChatView()
    }
  }
}