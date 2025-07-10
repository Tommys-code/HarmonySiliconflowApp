import { ApikeyStore, Failed, Loading, ResourceType, Success, UserInfoStore } from "common";
import { UserInfo } from "common/src/main/ets/models/UserInfoModel";

@ObservedV2
export class UserInfoViewModel {
  @Trace userInfo?: UserInfo = UserInfoStore.getInstance().userInfo
  @Trace apikey?: string
  @Trace logoutState?: ResourceType<boolean>

  constructor() {
    this.apikey = ApikeyStore.getInstance().getApiKey()
  }

  logout() {
    this.logoutState = Loading.Progress
    UserInfoStore.getInstance().clearUserInfo()
    ApikeyStore.getInstance().logout().then(() => {
      this.logoutState = new Success(true)
    }).catch((err: Error) => {
      this.logoutState = new Failed(err)
    })
  }
}