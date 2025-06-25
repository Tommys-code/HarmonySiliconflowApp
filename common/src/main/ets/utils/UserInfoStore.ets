import { apikeyStore, SiliconFlowService } from '../../../../Index'
import { UserInfo } from '../models/UserInfoModel'

class UserInfoStore {
  private static instance: UserInfoStore
  userInfo?: UserInfo

  private constructor() {
  }

  async getUserInfo() {
    const apiKey = apikeyStore.getApiKey()
    if (apiKey) {
      const userInfoModel = await SiliconFlowService.getUserInfo(apiKey)
      this.userInfo = userInfoModel.data
    }
  }

  public static getInstance(): UserInfoStore {
    if (!UserInfoStore.instance) {
      UserInfoStore.instance = new UserInfoStore();
    }
    return UserInfoStore.instance;
  }
}

export const userInfoStore = UserInfoStore.getInstance()