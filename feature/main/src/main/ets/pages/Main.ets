import MainViewModel from "../viewmodel/MainViewModel";
import { display } from "@kit.ArkUI";
import { DrawerContent } from "../views/DrawContent";
import { MainView } from "../views/MainView";

@ComponentV2
export struct Main {
  @Local mainViewModel: MainViewModel = new MainViewModel();
  @Local screenWith: number = 280

  aboutToAppear(): void {
    this.screenWith = display.getDefaultDisplaySync().width
  }

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      DrawerContent({ mainViewModel: this.mainViewModel, })
        .width('100%')
        .height('100%')
      MainView({ mainViewModel: this.mainViewModel, })
        .height('100%')
        .width('100%')
        .onClick(() => {
          this.mainViewModel.hideDrawer()
        })
    }.showControlButton(false)
    .showSideBar(this.mainViewModel.showSideBar)
    .sideBarWidth(280)
    .onChange((value) => {
      this.mainViewModel.showSideBar = value
    })
  }
}
