import { ModelStore, sfHttp, TextAIModel } from '../../../../Index'
import { ChatRequest, ChatResponseModel, MessageModel } from '../models/ChatResponseModel'
import { UserInfoModel } from '../models/UserInfoModel'

export class SiliconFlowService {
  static USER_INFO_URL = "user/info"
  static CHAT_URL = "chat/completions"

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

  static chat(
    msgs: MessageModel[],
    onData: (data: ChatResponseModel) => void,
    finish?: () => void,
  ) {
    const request: ChatRequest = {
      model: ModelStore.getInstance().getCurrentModel().model,
      messages: msgs,
      max_tokens: ModelStore.getInstance().getCurrentModel().max_tokens,
      stream: true,
    }

    sfHttp.requestStream<ChatResponseModel>(
      SiliconFlowService.CHAT_URL,
      request,
      onData,
      finish,
    )
  }
}