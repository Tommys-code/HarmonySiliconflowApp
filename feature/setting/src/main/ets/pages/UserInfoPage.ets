import { ImageKnifeComponentV2 } from "@ohos/imageknife";
import { copyText, Loading, LoadingDialog, navigationTitle, NormalButton, ResourceType, Style, Success } from "common";
import { dealWithApiKey, formatPriceSimple } from "../utils/StringUtils";
import { UserInfoViewModel } from "../viewmodel/UserInfoViewModel";

@ComponentV2
struct UserInfoPage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()
  @Local userViewModel: UserInfoViewModel = new UserInfoViewModel()

  @Monitor("userViewModel.logoutState")
  loginStateChange(monitor: IMonitor) {
    const state: ResourceType<boolean> | undefined = monitor.value<ResourceType<boolean>>()?.now
    if (state instanceof Loading && state.loading) {
      LoadingDialog.show(this.getUIContext())
    } else {
      LoadingDialog.dismiss()
      if (state instanceof Success) {
        this.pageStack.clear()
      }
    }
  }

  @Builder
  ColumnItem(title: Resource, content: string | Resource, icon?: ResourceStr, onClick?: () => void) {
    Row() {
      Text(title).attributeModifier(Style.TitleMedium)
      Blank().layoutWeight(1)
      Text(content)
      if (icon) {
        Image(icon)
          .width(24)
          .height(24)
          .fillColor($r('[common].color.icon'))
          .margin({ left: 12 })
          .onClick(onClick)
      }
    }.width('100%')
    .padding({ top: 16, bottom: 16 })
  }

  build() {
    NavDestination() {
      Column() {
        if (this.userViewModel.userInfo) {
          ImageKnifeComponentV2({
            imageKnifeOption: {
              loadSrc: this.userViewModel.userInfo.image,
              errorholderSrc: 'https://sf-maas-uat-prod.oss-cn-shanghai.aliyuncs.com/profile_imgs/222.jpeg',
              objectFit: ImageFit.Cover,
              border: { radius: 50 },
            }
          }).width(100).height(100)
          Text(this.userViewModel.userInfo.name).fontSize(18).fontWeight(FontWeight.Medium)
            .margin({ top: 12 })

          Column() {
            this.ColumnItem(
              $r('[common].string.id'),
              this.userViewModel.userInfo.id,
              $r('[common].media.ic_content_copy'),
              this.copyID.bind(this)
            )
            Divider().strokeWidth(0.5)
            if (this.userViewModel.apikey) {
              this.ColumnItem($r('[common].string.api_key'), dealWithApiKey(this.userViewModel.apikey))
            }
          }.margin({ top: 12, left: 24, right: 24 })
          .padding({ left: 16, right: 16 })
          .borderRadius(12)
          .backgroundColor($r('[common].color.background_l1'))

          Column() {
            this.ColumnItem(
              $r('[common].string.total_balance'),
              formatPriceSimple(this.userViewModel.userInfo.totalBalance)
            )
            Divider().strokeWidth(0.5)
            this.ColumnItem(
              $r('[common].string.gift_balance'),
              formatPriceSimple(this.userViewModel.userInfo.balance)
            )
            Divider().strokeWidth(0.5)
            this.ColumnItem(
              $r('[common].string.charge_balance'),
              formatPriceSimple(this.userViewModel.userInfo.chargeBalance)
            )
          }.margin({ top: 12, left: 24, right: 24 })
          .padding({ left: 16, right: 16 })
          .borderRadius(12)
          .backgroundColor($r('[common].color.background_l1'))

          NormalButton(
            {
              text: $r('[common].string.logout'),
              wid: '100%',
              hei: 48,
              click: () => {
                this.userViewModel.logout()
              }
            }
          ).margin({ top: 56, left: 24, right: 24 })
        }
      }.width('100%').padding({ top: 30 })
    }
    .title(navigationTitle($r('[common].string.personal_info_title'), () => this.pageStack.pop()))
    .hideBackButton(true)
  }

  copyID() {
    if (this.userViewModel.userInfo) {
      copyText(this.userViewModel.userInfo.id)
      this.getUIContext().getPromptAction().showToast({ message: $r('[common].string.copy_success') })
    }
  }
}

@Builder
export function UserInfoPageBuilder() {
  UserInfoPage();
}