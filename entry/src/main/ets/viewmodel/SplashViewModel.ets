import { SFRoute, userInfoStore } from "common";

@ObservedV2
export default class SplashViewModel {
  @Trace nextPage?: string = undefined

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
      this.nextPage = SFRoute.MAIN
    } else {
      this.nextPage = SFRoute.LOGIN
    }
  }
}