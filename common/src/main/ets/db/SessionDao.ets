import { RdbDao } from 'rdbstore'
import { Session, SessionType } from './entity/Session'
import { relationalStore } from '@kit.ArkData'
import { systemDateTime } from '@kit.BasicServicesKit'
import { BaseDao } from './BaseDao'

export interface SessionDaoImpl {
  insert(text: string, type: SessionType, userId?: string): Promise<number>

  querySessions(userId: string): Promise<Session[]>

  deleteSession(sessionIDs: number[]): Promise<boolean>

  updateSessionTime(sessionID: number): Promise<number>

  updateSessionName(sessionID: number, name: string): Promise<boolean>

  onDataChange(useID: string, callback: (sessions: Session[]) => void): void

  offDataChange(): void
}

export class SessionDao extends BaseDao implements SessionDaoImpl {
  dao: RdbDao<Session>

  constructor(dao: RdbDao<Session>) {
    super()
    this.dao = dao
  }

  insert(text: string, type: SessionType, userId?: string | undefined): Promise<number> {
    const data = new Session()
    data.title = text
    data.userID = userId ?? ''
    data.sessionType = type
    return this.dao.insert(data).finally(() => {
      super.dataChange()
    })
  }

  async querySessions(userId: string): Promise<Session[]> {
    const userIdProp = this.dao.getProperty('userID')
    return this.dao.predicatesBuilder()
      .where(userIdProp.equalTo(userId))
      .orderByDesc(this.dao.getProperty('updateTime'))
      .build()
      .run()
  }

  async deleteSession(sessionIDs: number[]): Promise<boolean> {
    const idProp = this.dao.getProperty('id')
    const predicates = this.dao.predicatesBuilder().where(idProp.inOp(sessionIDs)).predicates
    return await this.dao.batchDelete(predicates).finally(() => {
      super.dataChange()
    }) > 0
  }

  updateSessionTime(sessionID: number): Promise<number> {
    const data = new Session()
    data.id = sessionID
    const values: relationalStore.ValuesBucket = {
      'updateTime': systemDateTime.getTime(true),
    }
    return this.dao.updatePartial(values, data).finally(() => {
      super.dataChange()
    })
  }

  async updateSessionName(sessionID: number, name: string): Promise<boolean> {
    const data = new Session()
    data.id = sessionID
    const values: relationalStore.ValuesBucket = {
      'title': name,
    }
    return await this.dao.updatePartial(values, data).finally(() => {
      super.dataChange()
    }) > 0
  }

  onDataChange(useID: string, callback: (sessions: Session[]) => void): void {
    this.querySessions(useID).then((data) => callback(data))
    const observer = () => {
      this.querySessions(useID).then((data) => callback(data))
    }
    super.addObserver(observer)
  }

  offDataChange(): void {
    super.removeObserver()
  }
}