import { AppDataBase, DeltaModel, ListDataSource, Role, SiliconFlowService, UserInfoStore } from 'common'
import { ChatHistory } from 'common/src/main/ets/db/ChatHistoryDao'
import { Session, SessionType } from 'common/src/main/ets/db/SessionDao'
import { ChatResult, Finish, Start, Progressing } from '../model/ChatResult'

@ObservedV2
export class ChatViewModel {
  private userInfoStore = UserInfoStore.getInstance()
  private appDataBase = AppDataBase.getInstance()!!
  @Trace answer: ChatResult = Finish.INSTANCE
  @Trace sessionList: Array<Session> = []
  @Trace currentSessionID?: number
  chatHistory: ListDataSource<ChatHistory> = new ListDataSource()

  @Monitor("currentSessionID")
  currentSessionIDChange(monitor: IMonitor) {
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
      this.appDataBase.chatHistoryDao.offDataChange()
      this.appDataBase.chatHistoryDao.onDataChange(sessionID, (data) => {
        this.chatHistory.setNewData(data)
      })
    } else {
      this.chatHistory.setNewData([])
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

  changeSession(sessionID?: number) {
    this.currentSessionID = sessionID
  }

  private dataAppend(data: DeltaModel) {
    if (this.answer instanceof Progressing) {
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
      this.answer = new Progressing(newData)
    } else {
      this.answer = new Progressing(data)
    }
  }

  private finish(chatID?: number) {
    if (this.answer instanceof Progressing && chatID) {
      this.appDataBase.chatHistoryDao.updateChatHistory(chatID, this.answer.data)
    }
    this.answer = Finish.INSTANCE
  }

  private async insertSendData(data: string) {
    if (this.currentSessionID) {
      this.appDataBase.sessionDao.updateSessionTime(this.currentSessionID)
    }
    const sessionID =
      this.currentSessionID ??
        await this.appDataBase.sessionDao.insert(data, SessionType.CHAT, this.userInfoStore.userInfo?.id)
    const history: ChatHistory = {
      id: -1,
      sessionId: sessionID ?? -1,
      sendContent: data,
      sendRole: Role.USER,
    }
    this.currentSessionID = sessionID
    return await this.appDataBase.chatHistoryDao.insert(history)
  }

  async deleteChatHistory(chatHistory: ChatHistory) {
    const success = await this.appDataBase.chatHistoryDao.deleteChatHistory(chatHistory.id)
    this.appDataBase.chatHistoryDao.getCountBySessionID(chatHistory.sessionId).then((count) => {
      if (count === 0) {
        this.appDataBase.sessionDao.deleteSession(chatHistory.sessionId)
      }
    })
    return success
  }

  async editSessionName(session: Session, name: string) {
    return await this.appDataBase.sessionDao.updateSessionName(session.id, name)
  }

  async deleteSession(session: Session) {
    const success = await this.appDataBase.sessionDao.deleteSession(session.id)
    this.appDataBase.chatHistoryDao.deleteChatHistoryBySessionID(session.id)
    return success
  }

  async batchDelete(sessionID: number[]) {
    const result = this.appDataBase.sessionDao.batchDelete(sessionID)
    this.appDataBase.chatHistoryDao.batchDelete(sessionID)
    return result
  }

  onCleared() {
    this.appDataBase.sessionDao.offDataChange()
  }
}