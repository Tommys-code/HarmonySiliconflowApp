import { sfHttp } from '../../../../Index'
import { UserInfoModel } from '../models/UserInfoModel'


export class SiliconFlowService {
  static USER_INFO_URL = "user/info"

  static getUserInfo(apiKey: string) {
    return sfHttp.get<UserInfoModel>(
      SiliconFlowService.USER_INFO_URL,
      undefined,
      arg => {
        if (arg.header) {
          arg.header['Authorization'] = `Bearer ${apiKey}`
        }
      }
    )
  }
}

