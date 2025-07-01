import { AppDataBase, DeltaModel, logger, Role, SiliconFlowService, UserInfoStore } from 'common'
import { ChatHistory } from 'common/src/main/ets/db/ChatHistoryDao'
import { Session } from 'common/src/main/ets/db/SessionDao'
import { ChatResult, Finish, Start, Progress } from '../model/ChatResult'

@ObservedV2
export class ChatViewModel {
  private userInfoStore = UserInfoStore.getInstance()
  private appDataBase = AppDataBase.getInstance()!!
  @Trace answer: ChatResult<DeltaModel> = Finish.INSTANCE
  @Trace sessionList: Session[] = []
  @Trace currentSessionID?: number
  @Trace chatHistory: ChatHistory[] = []

  @Monitor("currentSessionID")
  loginStateChange(monitor: IMonitor) {
    if (monitor.value()?.now != monitor.value()?.before) {
      this.onChatHistory(monitor.value<number>()?.now)
    }
  }

  constructor() {
    if (this.userInfoStore.userInfo !== undefined) {
      this.appDataBase.sessionDao.onDataChange(this.userInfoStore.userInfo?.id, (data) => {
        this.sessionList = data
        if (this.currentSessionID === undefined) {
          this.currentSessionID = data[0].id
        }
      })
    }
  }

  private onChatHistory(sessionID?: number) {
    if (sessionID) {
      this.appDataBase.chatHistoryDao.onDataChange(sessionID, (data) => {
        this.chatHistory = data
      })
    } else {
      this.chatHistory = []
    }
  }

  sendData(data: string) {
    this.insertSendData(data).then((chatID) => {
      this.answer = Start.INSTANCE
      SiliconFlowService.chat(
        [
          { role: Role.USER, content: data }
        ],
        (data) => {
          this.dataAppend(data.choices[0]?.delta)
        },
        () => {
          this.finish(chatID)
        }
      )
    })
  }

  private dataAppend(data: DeltaModel) {
    if (this.answer instanceof Progress) {
      let prevData = this.answer.data
      let newContent = prevData.content ? data.content
        ? prevData.content + data.content
        : prevData.content
        : data.content;
      let newReasoningContent = prevData.reasoning_content ? data.reasoning_content
        ? prevData.reasoning_content + data.reasoning_content
        : prevData.reasoning_content
        : data.reasoning_content;

      let newData: DeltaModel = {
        role: data.role,
        content: newContent,
        reasoning_content: newReasoningContent,
      }
      this.answer = new Progress(newData)
    } else {
      this.answer = new Progress(data)
    }
  }

  private finish(chatID?: number) {
    if (this.answer instanceof Progress && chatID) {
      this.appDataBase.chatHistoryDao.updateChatHistory(chatID, this.answer.data)
    }
    this.answer = Finish.INSTANCE
  }

  private async insertSendData(data: string) {
    const sessionID =
      this.currentSessionID ?? await this.appDataBase.sessionDao.insert(data, this.userInfoStore.userInfo?.id)
    const history: ChatHistory = {
      id: -1,
      sessionId: sessionID ?? -1,
      sendContent: data,
      sendRole: Role.USER,
    }
    this.currentSessionID = sessionID
    return await this.appDataBase.chatHistoryDao.insert(history)
  }

  destory() {
    this.appDataBase.sessionDao.offDataChange()
  }
}