import { BaseDao } from "./BaseDao";
import { relationalStore } from "@kit.ArkData";
import { systemDateTime } from "@kit.BasicServicesKit";
import { ImageRatio } from "../models/ImageRatio";
import { ImageGenerationsResponse } from "../models/ImageGenerationsResponse";

export class ImageCreationHistoryDao extends BaseDao {
  tableName: string = 'ImageCreationHistory';
  private static readonly SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS ImageCreationHistory ' +
    '(' +
    'ID INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    'sessionId INTEGER, ' +
    'prompt TEXT, ' +
    'ratio TEXT, ' +
    'batchSize INTEGER, ' +
    'createTime INTEGER, ' +
    'seed INTEGER, ' +
    'images TEXT, ' +
    'baseImage TEXT' +
    ')'

  async initDao() {
    return await this.store?.executeSql(ImageCreationHistoryDao.SQL_CREATE_TABLE)
  }

  onDataChange(sessionId: number, callback: (sessions: ImageCreationHistory[]) => void) {
    this.queryHistory(sessionId).then((data) => {
      callback(data)
    })
    super.onDataChangeDetail(async () => {
      callback(await this.queryHistory(sessionId))
    })
  }

  async insert(history: ImageCreationHistory) {
    let id: number = -1
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        sessionId: history.sessionId,
        prompt: history.prompt,
        ratio: history.ratio.value,
        batchSize: history.batchSize,
        createTime: systemDateTime.getTime(true),
      }
      id = await this.store.insert(this.tableName, data)
    }
    return id
  }

  async queryHistory(sessionId: number) {
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('sessionId', sessionId)
    predicates.orderByAsc('createTime')
    const result: ImageCreationHistory[] = []
    if (this.store !== undefined) {
      const resultSet = await this.store.query(predicates, ['ID', 'prompt', 'ratio', 'batchSize', 'images'])
      while (resultSet.goToNextRow()) {
        const session: ImageCreationHistory = {
          id: resultSet.getLong(resultSet.getColumnIndex('ID')),
          sessionId: sessionId,
          prompt: resultSet.getString(resultSet.getColumnIndex('prompt')),
          ratio: ImageRatio.fromValue(resultSet.getString(resultSet.getColumnIndex('ratio'))),
          batchSize: resultSet.getLong(resultSet.getColumnIndex('batchSize')),
          images: JSON.parse(resultSet.getString(resultSet.getColumnIndex('images'))),
        }
        result.push(session)
      }
      resultSet.close()
    }
    return result
  }

  async update(response: ImageGenerationsResponse, id: number) {
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('ID', id)
    if (this.store !== undefined) {
      const data: relationalStore.ValuesBucket = {
        images: JSON.stringify(response.images.map((value) => {
          value.url
        })),
        seed: response.seed,
      }
      this.store.update(data, predicates)
    }
  }
}

export interface ImageCreationHistory {
  id: number
  sessionId: number
  prompt: string
  ratio: ImageRatio,
  batchSize: number,
  images?: string[]
}