import { Rdb, RdbDao, RdbDatabase } from "rdbstore"
import { relationalStore } from "@kit.ArkData"
import { ChatHistory } from "./entity/ChatHistory"
import { Session } from "./entity/Session"
import { ImageCreationHistory } from "./entity/ImageCreationHistory"

export class DataBase {
  private db: RdbDatabase

  constructor(context: Context) {
    this.db = Rdb.databaseBuilder(context, {
      version: DBConstants.DB_VERSION,
      dbName: DBConstants.DB_NAME,
      entities: [Session, ChatHistory, ImageCreationHistory],
      migrations: [],
      encrypt: false,
      securityLevel: relationalStore.SecurityLevel.S3,
      autoMigrate: true
    }).build()
    this.db.initTask
  }

  get sessionDao() {
    return this.db.getDao(Session)
  }

  get chatHistoryDao() {
    return this.db.getDao(ChatHistory)
  }

  get imageCreationHistoryDao() {
    return this.db.getDao(ImageCreationHistory)
  }
}

class DBConstants {
  static readonly DB_VERSION = 2
  static readonly DB_NAME = "chat.db"
}