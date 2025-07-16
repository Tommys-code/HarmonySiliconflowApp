import { ImageCreationHistory, ImageStyle } from "common";
import { ImageCreationViewModel } from "../viewmodel/ImageCreationViewModel";
import { HistoryItemView } from "./HistoryItemView";

@ComponentV2
export struct CreationHistoryListView {
  @Param viewModel: ImageCreationViewModel = new ImageCreationViewModel()
  private scroller: Scroller = new Scroller()
  @Local canScrollDown: boolean = false

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      List({ scroller: this.scroller }) {
        LazyForEach(this.viewModel.history, (item: ImageCreationHistory) => {
          ListItem() {
            HistoryItemView({ history: item })
          }
        })
      }
      .width('100%')
      .height('100%')
      .padding({ left: 16, right: 16 })
      .scrollBar(BarState.Off)
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
    }
  }
}