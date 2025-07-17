import { navigationTitle, SFRoute } from "common";
import { ImageCreationViewModel } from "../viewmodel/ImageCreationViewModel";
import { CreationHistoryListView } from "../views/CreationHistotoryListView";
import { ImageCreationView } from "../views/ImageCreationView";

@ComponentV2
struct ImageCreationPage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()
  @Local viewModel: ImageCreationViewModel = new ImageCreationViewModel(
    this.pageStack.getParamByName(SFRoute.IMAGE_CREATION_PAGE)[0] as number
  );

  build() {
    NavDestination() {
      Column() {
        CreationHistoryListView({ viewModel: this.viewModel }).layoutWeight(1).width('100%')
        ImageCreationView({ viewModel: this.viewModel })
          .margin({ left: 12, right: 12, bottom: 12 })
      }.height('100%')
      .width('100%')
    }
    .title(navigationTitle($r('[common].string.image_creation_title'), () => this.pageStack.pop()))
    .hideBackButton(true)
    .onReady((context) => {
      context.pathInfo.param as number;
    })
  }
}

@Builder
export function ImageCreationPageBuilder() {
  ImageCreationPage();
}