import { RdbDao } from "rdbstore"
import { DeltaModel } from "../models/ChatResponseModel"
import { ChatHistory } from "./entity/ChatHistory"
import { relationalStore } from "@kit.ArkData"
import { BaseDao } from "./BaseDao"
import { util } from "@kit.ArkTS"

export interface ChatHistoryDaoImpl {
  insert(history: ChatHistory): Promise<number>

  queryChatHistory(sessionId: number): Promise<ChatHistory[]>

  updateChatHistory(id: number, model: DeltaModel): Promise<number>

  deleteChatHistory(id: number): Promise<boolean>

  getCountBySessionID(sessionID: number): Promise<number>

  deleteChatHistoryBySessionID(sessionID: number): Promise<number>

  batchDelete(sessionIDs: number[]): Promise<number>

  onDataChange(sessionId: number, callback: (sessions: ChatHistory[]) => void): void

  offDataChange(): void
}

export class ChatHistoryDao extends BaseDao implements ChatHistoryDaoImpl {
  dao: RdbDao<ChatHistory>

  constructor(dao: RdbDao<ChatHistory>) {
    super()
    this.dao = dao
  }

  insert(history: ChatHistory): Promise<number> {
    return this.dao.insert(history).finally(() => {
      super.dataChange()
    })
  }

  queryChatHistory(sessionId: number): Promise<ChatHistory[]> {
    const sessionIdProp = this.dao.getProperty('sessionId')
    return this.dao.predicatesBuilder()
      .where(sessionIdProp.equalTo(sessionId))
      .orderByAsc(this.dao.getProperty('createTime'))
      .build()
      .run()
  }

  updateChatHistory(id: number, model: DeltaModel): Promise<number> {
    const data = new ChatHistory()
    data.id = id
    const values: relationalStore.ValuesBucket = {
      receiveContent: model.content ?? null,
      receiveRole: model.role ?? null,
      thinking: model.reasoning_content ?? null,
    }
    return this.dao.updatePartial(values, data).finally(() => {
      super.dataChange()
    })
  }

  async deleteChatHistory(id: number): Promise<boolean> {
    const data = new ChatHistory()
    data.id = id
    return await this.dao.delete(data).finally(() => {
      super.dataChange()
    }) > 0
  }

  async getCountBySessionID(sessionID: number): Promise<number> {
    let count = 0;
    const sql = "SELECT COUNT(*) FROM ChatHistory WHERE sessionId = ?"
    const resultSet = await this.dao.queryRawSql(sql, [sessionID])
    if (resultSet.goToFirstRow()) {
      count = resultSet.getLong(0);
    }
    return count
  }

  async deleteChatHistoryBySessionID(sessionID: number): Promise<number> {
    const sessionIDProp = this.dao.getProperty('sessionId')
    const predicates = this.dao.predicatesBuilder().where(sessionIDProp.equalTo(sessionID)).predicates
    return await this.dao.batchDelete(predicates).finally(() => {
      super.dataChange()
    })
  }

  batchDelete(sessionIDs: number[]): Promise<number> {
    const sessionIDProp = this.dao.getProperty('sessionId')
    const predicates = this.dao.predicatesBuilder().where(sessionIDProp.inOp(sessionIDs)).predicates
    return this.dao.batchDelete(predicates).finally(() => {
      super.dataChange()
    })
  }

  onDataChange(sessionId: number, callback: (sessions: ChatHistory[]) => void): void {
    this.queryChatHistory(sessionId).then((data) => callback(data))
    const observer = () => {
      this.queryChatHistory(sessionId).then((data) => callback(data))
    }
    super.addObserver(observer)
  }

  offDataChange(): void {
    super.removeObserver()
  }
}

export function getChatHistoryKey(chatHistory: ChatHistory): string {
  return util.getHash(chatHistory).toString()
}