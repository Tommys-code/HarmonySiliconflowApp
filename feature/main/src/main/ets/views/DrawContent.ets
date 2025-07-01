import { Session } from "common/src/main/ets/db/SessionDao";
import MainViewModel from "../viewmodel/MainViewModel";

@ComponentV2
export struct DrawerContent {
  @Param mainViewModel: MainViewModel = new MainViewModel()

  @Builder
  SessionList() {
    List() {
      ForEach(this.mainViewModel.sessionList, (item: Session) => {
        ListItem() {
          Text(item.title)
        }
      })
    }
  }

  build() {
    Column() {
      this.SessionList()
    }
  }
}