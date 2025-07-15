import { ImageStyle, ModelStore, SFRoute, TextAIModel } from "common";
import MainViewModel from "../viewmodel/MainViewModel";
import { NewChatMenu } from "./dialog/NewChatMenu";

@ComponentV2
export struct HomeTopAppBar {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()
  @Local currentModel: TextAIModel = ModelStore.getInstance().getCurrentModel()
  @Param viewModel: MainViewModel = new MainViewModel()
  @Event toggleDrawer: () => void = () => {
  };

  @Builder
  Title() {
    Stack({ alignContent: Alignment.Center }) {
      Row() {
        Text(this.currentModel.model)
          .textAlign(TextAlign.Center)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .ellipsisMode(EllipsisMode.END)
          .constraintSize({
            maxWidth: 200
          })
        Image($r('[common].media.ic_drop_down'))
          .attributeModifier(ImageStyle.Small)
      }.onClick(() => {
        this.pageStack.pushPath({
          name: SFRoute.MODEL_LIST_PAGE, onPop: (data) => {
            this.currentModel = data.result as TextAIModel
          }
        })
      })
    }.layoutWeight(1)
  }

  build() {
    Row() {
      Image($r('[common].media.ic_dehaze'))
        .attributeModifier(ImageStyle.Normal)
        .onClick(() => {
          this.toggleDrawer()
        })
      this.Title()
      Image($r('[common].media.ic_circle_add'))
        .attributeModifier(ImageStyle.Normal)
        .bindMenu(NewChatMenu({
          newChat: () => this.viewModel.newChat(),
          newImageCreation: () => this.pageStack.pushPath({ name: SFRoute.IMAGE_CREATION_PAGE })
        }))
    }
    .height(64)
    .width('100%')
    .padding({ left: 16, right: 16 })
  }
}
