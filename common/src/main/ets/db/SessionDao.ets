import { relationalStore } from "@kit.ArkData";
import { BaseDao } from "./BaseDao";
import { systemDateTime } from "@kit.BasicServicesKit";

export class SessionDao extends BaseDao {
  tableName: string = 'SESSION'
  private static readonly SQL_CREATE_SESSION_TABLE = 'CREATE TABLE IF NOT EXISTS SESSION ' +
    '(' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'title TEXT NOT NULL, ' +
    'updateTime INTEGER, ' +
    'userID TEXT NOT NULL' +
    ')'

  initDao(store: relationalStore.RdbStore): void {
    if (store.version === 0) {
      store.executeSql(SessionDao.SQL_CREATE_SESSION_TABLE)
    }
  }

  onDataChange(useID: string, callback: (sessions: Session[]) => void) {
    this.querySessions(useID).then((data) => {
      callback(data)
    })
    super.onDataChangeDetail(async () => {
      callback(await this.querySessions(useID))
    })
  }

  async insert(text: string, userId?: string) {
    let id: number = -1
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        title: text,
        updateTime: systemDateTime.getTime(true),
        userID: userId ?? '',
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
          title: resultSet.getString(resultSet.getColumnIndex('title'))
        }
        result.push(session)
      }
      resultSet.close()
    }
    return result
  }
}

export interface Session {
  id: number
  title: string
}