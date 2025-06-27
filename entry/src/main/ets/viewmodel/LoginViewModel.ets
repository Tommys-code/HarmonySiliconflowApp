import { apikeyStore, Failed, Loading, ResourceType, Success, userInfoStore } from "common"
import { UserInfo } from "common/src/main/ets/models/UserInfoModel"

@ObservedV2
export default class LoginViewModel {
  @Trace apiKey: string
  @Trace loginState?: ResourceType<UserInfo>

  constructor() {
    this.apiKey = apikeyStore.getApiKey() || ''
  }

  async login() {
    this.loginState = Loading.Progress
    userInfoStore.login(this.apiKey).then((userInfo) => {
      if (userInfo) {
        this.loginState = new Success(userInfo)
      } else {
        throw new Error("empty data")
      }
    }).catch((err: Error) => {
      this.loginState = new Failed(err)
    })
  }
}