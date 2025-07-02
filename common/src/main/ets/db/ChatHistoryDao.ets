import { BaseDao } from "./BaseDao";
import { relationalStore } from "@kit.ArkData";
import { Role } from "../models/Role";
import { BusinessError } from "@kit.BasicServicesKit";
import { logger } from "../utils/Logger";
import { DeltaModel } from "../models/ChatResponseModel";
import { util } from "@kit.ArkTS";

export class ChatHistoryDao extends BaseDao {
  tableName: string = 'ChatHistory'
  private static readonly SQL_CREATE_CHAT_HISTORY_TABLE = 'CREATE TABLE IF NOT EXISTS ChatHistory ' +
    '(' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'sessionId INTEGER, ' +
    'send_content TEXT, ' +
    'send_role TEXT, ' +
    'receive_content TEXT, ' +
    'receive_role TEXT, ' +
    'createTime INTEGER, ' +
    'thinking TEXT' +
    ')'

  initDao(store: relationalStore.RdbStore) {
    if (store.version === 0) {
      store.executeSql(ChatHistoryDao.SQL_CREATE_CHAT_HISTORY_TABLE).catch((e: BusinessError) => {
        logger.error(e.message)
      })
    }
  }

  onDataChange(sessionId: number, callback: (sessions: ChatHistory[]) => void) {
    this.queryChatHistory(sessionId).then((data) => {
      callback(data)
    })
    super.onDataChangeDetail(async () => {
      callback(await this.queryChatHistory(sessionId))
    })
  }

  async insert(history: ChatHistory) {
    let id: number = -1
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        sessionId: history.sessionId,
        send_content: history.sendContent ?? null,
        send_role: history.sendRole?.toString() ?? null,
        receive_content: history.receiveContent?.toString() ?? null,
        receive_role: history.receiveRole?.toString() ?? null,
        thinking: history.thinking ?? null,
      }
      id = await this.store.insert(this.tableName, data)
    }
    return id
  }

  async queryChatHistory(sessionId: number) {
    const predicates2 = new relationalStore.RdbPredicates(this.tableName);
    predicates2.equalTo('sessionId', sessionId)
    predicates2.orderByAsc('createTime')
    const result: ChatHistory[] = []
    if (this.store !== undefined) {
      const resultSet = await this.store.query(predicates2, ['ID', 'send_content', 'receive_content', 'thinking'])
      while (resultSet.goToNextRow()) {
        const session: ChatHistory = {
          id: resultSet.getLong(resultSet.getColumnIndex('ID')),
          sessionId: sessionId,
          sendContent: resultSet.getString(resultSet.getColumnIndex('send_content')),
          receiveContent: resultSet.getString(resultSet.getColumnIndex('receive_content')),
          thinking: resultSet.getString(resultSet.getColumnIndex('thinking')),
        }
        result.push(session)
      }
      resultSet.close()
    }
    return result
  }

  async updateChatHistory(id: number, model: DeltaModel) {
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('ID', id)
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        receive_content: model.content ?? null,
        receive_role: model.role ?? null,
        thinking: model.reasoning_content ?? null,
      }
      this.store.update(data, predicates)
    }
  }
}

export interface ChatHistory {
  id: number
  sessionId: number
  sendContent?: string
  sendRole?: Role
  receiveContent?: string
  receiveRole?: Role
  thinking?: string
}

export function getChatHistoryKey(chatHistory: ChatHistory): string {
  return util.getHash(chatHistory).toString()
}

