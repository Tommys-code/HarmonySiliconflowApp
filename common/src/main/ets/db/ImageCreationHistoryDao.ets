import { RdbDao } from "rdbstore"
import { ImageGenerationsResponse } from "../models/ImageGenerationsResponse"
import { ImageCreationHistory } from "./entity/ImageCreationHistory"
import { relationalStore } from "@kit.ArkData"
import { BaseDao } from "./BaseDao"

export interface ImageCreationHistoryDaoImpl {
  insert(history: ImageCreationHistory): Promise<number>

  queryHistory(sessionId: number): Promise<ImageCreationHistory[]>

  update(response: ImageGenerationsResponse, id: number): Promise<number>

  onDataChange(sessionId: number, callback: (sessions: ImageCreationHistory[]) => void): void

  offDataChange(): void
}

export class ImageCreationHistoryDao extends BaseDao implements ImageCreationHistoryDaoImpl {
  dao: RdbDao<ImageCreationHistory>

  constructor(dao: RdbDao<ImageCreationHistory>) {
    super()
    this.dao = dao
  }

  insert(history: ImageCreationHistory): Promise<number> {
    return this.dao.insert(history).finally(() => {
      super.dataChange()
    })
  }

  queryHistory(sessionId: number): Promise<ImageCreationHistory[]> {
    const sessionIdProp = this.dao.getProperty('sessionId')
    return this.dao.predicatesBuilder()
      .where(sessionIdProp.equalTo(sessionId))
      .orderByAsc(this.dao.getProperty('createTime'))
      .build()
      .run()
  }

  update(response: ImageGenerationsResponse, id: number): Promise<number> {
    const data = new ImageCreationHistory()
    data.id = id
    const values: relationalStore.ValuesBucket = {
      images: JSON.stringify(response.images.map((value) => {
        value.url
      })),
      seed: response.seed,
    }
    return this.dao.updatePartial(values, data).finally(() => {
      super.dataChange()
    })
  }

  onDataChange(sessionId: number, callback: (sessions: ImageCreationHistory[]) => void) {
    this.queryHistory(sessionId).then((data) => callback(data))
    const observer = () => {
      this.queryHistory(sessionId).then((data) => callback(data))
    }
    super.addObserver(observer)
  }

  offDataChange(): void {
    super.removeObserver()
  }
}