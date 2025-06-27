import { Loading, LoadingDialog, ResourceType, SFRoute, Style, Success } from 'common';
import LoginViewModel from '../viewmodel/LoginViewModel';
import { PersistenceV2, router } from '@kit.ArkUI';
import { UserInfo } from 'common/src/main/ets/models/UserInfoModel';

@ComponentV2
export struct Login {
  @Local login: LoginViewModel = PersistenceV2.connect(LoginViewModel, "Login", () => new LoginViewModel())!;
  @Event loginSuccess: () => void = () => {
  };

  @Monitor("login.loginState")
  loginStateChange(monitor: IMonitor) {
    const state: ResourceType<UserInfo> | undefined = monitor.value<ResourceType<UserInfo>>()?.now
    if (state instanceof Loading && state.loading) {
      LoadingDialog.show(this.getUIContext())
    } else {
      LoadingDialog.dismiss()
      if (state instanceof Success) {
        this.loginSuccess()
      }
    }
  }

  build() {
    NavDestination() {
      RelativeContainer() {
        Column() {
          Image($r('app.media.ic_silicon_flow'))
            .height(60)
            .objectFit(ImageFit.Cover)
          Text($r('app.string.add_key_title'))
            .attributeModifier(Style.TitleLarge)
            .margin({ top: 8, bottom: 8 })
          TextInput({ text: this.login.apiKey, placeholder: $r('app.string.add_key_hilt') })
            .backgroundColor($r('[common].color.background_l1'))
            .onChange((value: string) => {
              this.login.apiKey = value.trim()
            })
            .onSubmit((_enterKey: EnterKeyType) => {
              this.login.login()
            })
            .borderRadius(2)
            .height(48)
            .width('100%')
            .margin({
              left: 18,
              right: 18,
              top: 10,
              bottom: 10,
            })
          Button($r('[common].string.confirm'))
            .type(ButtonType.Normal)
            .borderRadius(0)
            .enabled(this.login.apiKey.trim().length > 0)
            .width('100%')
            .height(48)
            .margin({
              left: 18,
              right: 18,
              top: 10,
              bottom: 10,
            })
            .onClick(() => {
              this.login.login()
            })
        }
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
        .width('80%')
      }
      .height('100%')
      .width('100%')
    }
  }
}