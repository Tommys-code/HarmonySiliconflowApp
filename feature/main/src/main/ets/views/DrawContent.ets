import { ImageKnifeComponentV2 } from "@ohos/imageknife";
import { NormalButton, Style, UserInfoStore } from "common";
import { Session } from "common/src/main/ets/db/SessionDao";
import { getSessionListBackgroundColor } from "../utils/SessionUtils";
import MainViewModel from "../viewmodel/MainViewModel";
import { SessionMenu } from "./dialog/SessionMenu";

@ComponentV2
export struct DrawerContent {
  @Param mainViewModel: MainViewModel = new MainViewModel()
  private userInfo = UserInfoStore.getInstance().userInfo

  @Builder
  NewChatButton() {
    Stack() {
      Button({ type: ButtonType.ROUNDED_RECTANGLE }) {
        Row({ space: 10 }) {
          Image($r('[common].media.ic_circle_add')).width(24).height(24)
            .fillColor($r('[common].color.icon'))
          Text($r('[common].string.create_new_session')).fontSize(15)
        }
      }
      .width('100%')
      .height(40)
      .borderRadius(10)
      .backgroundColor($r('[common].color.background_l1'))
      .onClick(() => {
        this.mainViewModel.newChat()
      })
    }.width('100%')
    .padding({
      left: 16,
      right: 16,
      top: 8,
      bottom: 8
    })
  }

  @Builder
  SessionList() {
    List({ space: 4 }) {
      ForEach(this.mainViewModel.sessionList, (item: Session) => {
        ListItem() {
          Row() {
            Text(item.title).maxLines(1).layoutWeight(1).padding({ top: 12, bottom: 12 })
            if (this.mainViewModel.multiSelect) {
              Checkbox().select(this.mainViewModel.selectedItem.includes(item))
                .onClick(() => {
                  this.mainViewModel.selected(item)
                })
            }
          }
          .padding({ left: 12, right: 12 })
          .width('100%')
          .backgroundColor(getSessionListBackgroundColor(item.id, this.mainViewModel.currentSessionID))
          .borderRadius(10)
          .onClick(() => {
            if (this.mainViewModel.multiSelect) {
              this.mainViewModel.selected(item)
            } else {
              this.mainViewModel.newChat(item.id)
            }
          })
        }.margin({ left: 12, right: 12 })
        .bindContextMenu(
          SessionMenu({
            multiAble: this.mainViewModel.multiSelect,
            multiSelect: this.mainViewModel.toggleMultiSelected
          }),
          ResponseType.LongPress
        )
      })
    }.layoutWeight(1)
    .width('100%')
  }

  @Builder
  Bottom() {
    Row() {
      Row() {
        ImageKnifeComponentV2({
          imageKnifeOption: {
            loadSrc: this.userInfo?.image,
            objectFit: ImageFit.Cover,
            border: { radius: 18 },
          }
        })
          .width(36).height(36).margin({ right: 8 })
        Text(this.userInfo?.name)
      }

      Stack().layoutWeight(1)
      Image($r('[common].media.ic_settings'))
        .width(36)
        .height(36)
        .fillColor($r('[common].color.icon'))
    }.width('100%')
    .height(40)
    .padding({ left: 12, right: 12 })
  }

  @Builder
  MultiBottom() {
    Row() {
      Row({ space: 8 }) {
        Checkbox()
          .select(this.mainViewModel.selectedItem.length == this.mainViewModel.sessionList.length)
          .onClick(() => {
            this.mainViewModel.selectedAllClick()
          })
        Text($r('[common].string.select_all'))
      }.height('100%')
      .onClick(() => {
        this.mainViewModel.selectedAllClick()
      })

      Stack().layoutWeight(1)
      NormalButton({
        text: $r('[common].string.cancel'),
        borderOptions: {
          width: 1,
          color: $r('[common].color.outline_variant')
        },
        color: $r('[common].color.transparent'),
        click: this.mainViewModel.toggleMultiSelected
      }).height(32)
        .margin({ right: 12 })
      NormalButton({
        text: this.mainViewModel.selectedItem.length > 0 ?
        $r('[common].string.delete_with_num', this.mainViewModel.selectedItem.length) : $r('[common].string.delete'),
        borderOptions: {
          width: 1,
          color: $r('[common].color.outline_variant'),
        },
        textColor: $r('[common].color.white'),
        color: $r('[common].color.highlight'),
        enable: this.mainViewModel.selectedItem.length > 0,
      }).height(32)
    }.width('100%')
    .height(40)
    .padding({ left: 12, right: 12 })
  }

  build() {
    Column() {
      Text($r('[common].string.title'))
        .attributeModifier(Style.TitleLarge)
        .padding({
          left: 20,
          right: 20,
          top: 12,
          bottom: 12
        })
      Divider().strokeWidth(1)
      this.NewChatButton()
      Divider().strokeWidth(1).margin({ left: 8, right: 8, bottom: 8 })
      this.SessionList()
      Divider().strokeWidth(1)
      if (this.mainViewModel.multiSelect) {
        this.MultiBottom()
      } else {
        this.Bottom()
      }
    }
    .height('100%')
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor($r('[common].color.background'))
  }
}