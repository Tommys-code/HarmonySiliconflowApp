import { ApikeyStore, SiliconFlowService } from '../../../../Index'
import { UserInfo } from '../models/UserInfoModel'

export class UserInfoStore {
  private static instance: UserInfoStore
  userInfo?: UserInfo

  private constructor() {
  }

  async getUserInfo() {
    const apiKey = ApikeyStore.getInstance().getApiKey()
    if (apiKey) {
      const userInfoModel = await SiliconFlowService.getUserInfo(apiKey)
      this.userInfo = userInfoModel.data
    }
  }

  async login(apikey: string) {
    const userInfoModel = await SiliconFlowService.getUserInfo(apikey)
    if (userInfoModel.data) {
      await ApikeyStore.getInstance().saveApiKey(apikey)
      this.userInfo = userInfoModel.data
    }
    return userInfoModel.data
  }

  public static getInstance(): UserInfoStore {
    if (!UserInfoStore.instance) {
      UserInfoStore.instance = new UserInfoStore();
    }
    return UserInfoStore.instance;
  }
}