import { relationalStore } from "@kit.ArkData";
import { BaseDao } from "./BaseDao";
import { systemDateTime } from "@kit.BasicServicesKit";

export class SessionDao extends BaseDao {
  tableName: string = 'SESSION'
  private static readonly SQL_CREATE_SESSION_TABLE = 'CREATE TABLE IF NOT EXISTS SESSION ' +
    '(' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'title TEXT NOT NULL, ' +
    'sessionType TEXT, ' +
    'updateTime INTEGER, ' +
    'userID TEXT NOT NULL' +
    ')'
  private static readonly ADD_COLUMN_TYPE = 'ALTER TABLE SESSION ADD COLUMN sessionType TEXT'

  async initDao(store: relationalStore.RdbStore) {
    return await store.executeSql(SessionDao.SQL_CREATE_SESSION_TABLE)
  }

  async upgrade1() {
    await this.store?.executeSql('ALTER TABLE SESSION ADD COLUMN sessionType TEXT')
  }

  onDataChange(useID: string, callback: (sessions: Session[]) => void) {
    this.querySessions(useID).then((data) => {
      callback(data)
    })
    super.onDataChangeDetail(async () => {
      callback(await this.querySessions(useID))
    })
  }

  async insert(text: string, type: SessionType, userId?: string) {
    let id: number = -1
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        title: text,
        updateTime: systemDateTime.getTime(true),
        userID: userId ?? '',
        sessionType: type,
      }
      id = await this.store.insert(this.tableName, data)
    }
    return id
  }

  async querySessions(useID: string) {
    const predicates2 = new relationalStore.RdbPredicates(this.tableName);
    predicates2.equalTo('userID', useID)
    predicates2.orderByDesc('updateTime')
    const result: Session[] = []
    if (this.store !== undefined) {
      const resultSet = await this.store.query(predicates2, ['ID', 'title'])
      while (resultSet.goToNextRow()) {
        const session: Session = {
          id: resultSet.getLong(resultSet.getColumnIndex('ID')),
          title: resultSet.getString(resultSet.getColumnIndex('title')),
          type: stringToSessionType(resultSet.getString(resultSet.getColumnIndex('sessionType'))),
        }
        result.push(session)
      }
      resultSet.close()
    }
    return result
  }

  async deleteSession(sessionID: number) {
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    let result: boolean = false
    predicates.equalTo('ID', sessionID)
    if (this.store !== undefined) {
      const num = await this.store.delete(predicates)
      result = num > 0
    }
    return result
  }

  async updateSessionTime(sessionID: number) {
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('ID', sessionID)
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        updateTime: systemDateTime.getTime(true)
      }
      this.store.update(data, predicates)
    }
  }

  async updateSessionName(sessionID: number, name: string) {
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('ID', sessionID)
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        title: name
      }
      const result = await this.store.update(data, predicates) >= 0
      return result
    }
    return false
  }

  async batchDelete(sessionIDS: number[]) {
    if (this.store !== undefined) {
      const placeholders = sessionIDS.map(() => '?').join(',');
      const sql = `DELETE FROM SESSION WHERE ID IN (${placeholders})`;
      const result = await this.store.executeSql(sql, sessionIDS)
      return result
    }
    return undefined
  }
}

export interface Session {
  id: number
  title: string
  type: SessionType
}

export enum SessionType {
  CHAT = 'chat',
  IMAGE = 'image'
}

export function stringToSessionType(value: string): SessionType {
  return Object.values(SessionType).find((type) => type === value) || SessionType.CHAT;
}