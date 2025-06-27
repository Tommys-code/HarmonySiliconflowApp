import { userInfoStore } from "common";

@ObservedV2
export default class SplashViewModel {
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
      userInfoStore.getUserInfo()
    ])
    if (userInfoStore.userInfo) {
      this.isLogin = true
    } else {
      this.isLogin = false
    }
  }
}