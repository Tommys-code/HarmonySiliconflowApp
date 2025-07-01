import { relationalStore } from "@kit.ArkData";
import { BaseDao } from "./BaseDao";
import { ChatHistoryDao } from "./ChatHistoryDao";
import { SessionDao } from "./SessionDao";

export class AppDataBase {
  private static instance: AppDataBase
  private static readonly DB_NAME = "chat.db"
  private static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: AppDataBase.DB_NAME,
    securityLevel: relationalStore.SecurityLevel.S3,
    encrypt: false,
  }
  private store?: relationalStore.RdbStore
  private dao: BaseDao[] = []

  private constructor(context: Context) {
    relationalStore.getRdbStore(context, AppDataBase.STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      this.store = store
      this.initDao(store)
    })
  }

  private initDao(store: relationalStore.RdbStore) {
    this.dao = [
      new SessionDao(store),
      new ChatHistoryDao(store)
    ]
  }

  get sessionDao(): SessionDao {
    if (!this.dao || this.dao.length === 0) {
      throw new Error('DAO数组未初始化');
    }

    const sessionDao = this.dao[0] as SessionDao;
    if (!sessionDao) {
      throw new Error('Session DAO不存在');
    }

    return sessionDao;
  }

  get chatHistoryDao(): ChatHistoryDao {
    if (!this.dao || this.dao.length === 0) {
      throw new Error('DAO数组未初始化');
    }
    const chatHistoryDao = this.dao[1] as ChatHistoryDao;
    if (!chatHistoryDao) {
      throw new Error('ChatHistory DAO不存在');
    }
    return chatHistoryDao;
  }

  static createAppDatabase(context: Context) {
    if (!AppDataBase.instance) {
      AppDataBase.instance = new AppDataBase(context);
    }
    return AppDataBase.instance;
  }

  static getInstance() {
    if (!AppDataBase.instance) {
      console.error(`must createAppDatabase first`);
      return;
    }
    return AppDataBase.instance
  }
}
