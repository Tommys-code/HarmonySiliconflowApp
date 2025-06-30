import MainViewModel from "../viewmodel/MainViewModel";
import { MainView } from "../views/MainView";
import { PersistenceV2 } from "@kit.ArkUI";

@ComponentV2
export struct Main {
  @Local mainViewModel: MainViewModel = PersistenceV2.connect(MainViewModel, "Main", () => new MainViewModel())!;

  build() {
    SideBarContainer(SideBarContainerType.Overlay) {
      Row() {
        Text("11111")
      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('[common].color.background_l1'))
      MainView({ mainViewModel: this.mainViewModel, })
        .height('100%')
        .width('100%')
        .onClick(() => {
          this.mainViewModel.hideDrawer()
        })
    }.showControlButton(false)
    .showSideBar(this.mainViewModel.showSideBar)
    .sideBarWidth(240)
    .onChange((value) => {
      this.mainViewModel.showSideBar = value
    })
  }
}
