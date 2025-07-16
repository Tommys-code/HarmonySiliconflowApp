import { navigationTitle } from "common";
import { ImageCreationViewModel } from "../viewmodel/ImageCreationViewModel";
import { CreationHistoryListView } from "../views/CreationHistotoryListView";
import { ImageCreationView } from "../views/ImageCreationView";

@ComponentV2
struct ImageCreationPage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()
  @Local viewModel: ImageCreationViewModel = new ImageCreationViewModel();

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
  }
}

@Builder
export function ImageCreationPageBuilder() {
  ImageCreationPage();
}