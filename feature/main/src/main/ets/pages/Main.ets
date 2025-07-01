import MainViewModel from "../viewmodel/MainViewModel";
import { MainView } from "../views/MainView";
import { PersistenceV2 } from "@kit.ArkUI";
import { DrawerContent } from "../views/DrawContent";

@ComponentV2
export struct Main {
  @Local mainViewModel: MainViewModel = PersistenceV2.connect(MainViewModel, "Main", () => new MainViewModel())!;

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      DrawerContent({ mainViewModel: this.mainViewModel, })
        .width('100%')
        .height('100%')
        .backgroundColor($r('[common].color.background'))
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
