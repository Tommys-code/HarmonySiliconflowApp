import { UserInfoStore } from "common";

@ObservedV2
export default class SplashViewModel {
  private userInfoStore = UserInfoStore.getInstance()
  @Trace isLogin?: boolean = undefined

  constructor() {
    this.init()
  }

  async init() {
    await Promise.all([
      new Promise<void>((resolve) => {
        setTimeout(() => {
          resolve();
        }, 1000);
      }),
      this.userInfoStore.getUserInfo()
    ])
    if (this.userInfoStore.userInfo) {
      this.isLogin = true
    } else {
      this.isLogin = false
    }
  }
}