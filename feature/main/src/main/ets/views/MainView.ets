import MainViewModel from '../viewmodel/MainViewModel';
import { HomeTopAppBar } from './HomeTopAppBar'
import { inputMethod } from '@kit.IMEKit';
import { ImageStyle, ListDataSourceDataChange } from 'common';
import { Answer, ChatItem } from './ChatItem';
import { ChatHistory } from 'common/src/main/ets/db/entity/ChatHistory';
import { getChatHistoryKey } from 'common/src/main/ets/db/ChatHistoryDao';

@ComponentV2
export struct MainView {
  @Param mainViewModel: MainViewModel = new MainViewModel()
  private dataChangeListener = new ListDataSourceDataChange(() => {
    this.chatHistoryChange()
  })
  private scroller: Scroller = new Scroller()
  @Local canScrollDown: boolean = false

  @Monitor('mainViewModel.answer')
  onAnswerChange() {
    this.chatHistoryChange()
  }

  aboutToAppear(): void {
    this.mainViewModel.chatHistory.registerDataChangeListener(this.dataChangeListener)
  }

  aboutToDisappear(): void {
    this.mainViewModel.chatHistory.unregisterDataChangeListener(this.dataChangeListener)
    this.mainViewModel.onCleared()
  }

  chatHistoryChange() {
    if (this.canScrollDown === false) {
      this.scroller.scrollEdge(Edge.Bottom)
    }
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
          inputMethod.getController().stopInputSession()
          this.scroller.scrollEdge(Edge.Bottom)
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
        this.scroller.scrollEdge(Edge.Bottom)
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
    Stack({ alignContent: Alignment.Bottom }) {
      List({ scroller: this.scroller }) {
        LazyForEach(this.mainViewModel.chatHistory, (item: ChatHistory) => {
          ListItem() {
            ChatItem({ data: item, mainViewModel: this.mainViewModel })
          }
        }, (item: ChatHistory) => getChatHistoryKey(item))
        ListItem() {
          Answer({ data: this.mainViewModel.answer })
        }
      }
      .padding({ left: 16, right: 16 })
      .scrollBar(BarState.Off)
      .width('100%')
      .height('100%')
      .onDidScroll(() => {
        this.canScrollDown = !this.scroller.isAtEnd()
      })

      if (this.canScrollDown) {
        Image($r('[common].media.ic_arrow_down'))
          .attributeModifier(ImageStyle.Normal)
          .margin({ bottom: 24 })
          .backgroundColor($r('[common].color.pop_container'))
          .borderRadius(18)
          .shadow({
            radius: 2,
            offsetX: 0,
            offsetY: 5
          })
          .onClick(() => {
            this.scroller.scrollEdge(Edge.Bottom)
          })
      }
    }.width('100%')
    .layoutWeight(1)
  }

  build() {
    Column() {
      HomeTopAppBar({ toggleDrawer: this.mainViewModel.toggleDrawer, viewModel: this.mainViewModel })
      this.ChatList()
      this.ChatView()
    }
  }
}