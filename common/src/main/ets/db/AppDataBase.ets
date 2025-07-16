import { relationalStore } from "@kit.ArkData";
import { logger } from "../../../../Index";
import { BaseDao, IRdbUpgrade } from "./BaseDao";
import { ChatHistoryDao } from "./ChatHistoryDao";
import { ImageCreationHistoryDao } from "./ImageCreationHistoryDao";
import { SessionDao } from "./SessionDao";

export class AppDataBase {
  private static instance: AppDataBase
  private static readonly DB_NAME = "chat.db"
  private static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: AppDataBase.DB_NAME,
    securityLevel: relationalStore.SecurityLevel.S3,
    encrypt: false,
  }
  private dao: BaseDao[] = []
  private targetVersion = 3
  private upgradeOper: IRdbUpgrade[] = [new V2Upgrade(), new V4Upgrade()]

  private constructor(context: Context) {
    this.init(context)
  }

  private async init(context: Context) {
    relationalStore.getRdbStore(context, AppDataBase.STORE_CONFIG, (err, store) => {
      if (err) {
        console.error(`Failed to get RdbStore. Code:${err.code}, message:${err.message}`);
        return;
      }
      this.initDao(store)
      switch (store.version) {
        case 0:
          this.doCreate(store)
          break
        default:
          this.doUpgrade(store)
      }
    })
  }

  private async doCreate(store: relationalStore.RdbStore) {
    store.beginTransaction()
    try {
      const promises = this.dao.map(async (dao) => {
        await dao.initDao(store)
      })
      await Promise.all(promises)
      store.version = this.targetVersion
      store.commit()
    } catch (e) {
      logger.info(e)
      store.rollBack()
    }
  }

  private async doUpgrade(store: relationalStore.RdbStore) {
    let sortUpgradeOper = this.upgradeOper
      .sort((pre, post) => pre.getVersion() - post.getVersion())
      .filter((upgrade) => upgrade.getVersion() > store.version)
    try {
      store.beginTransaction()
      for (let i = 0; i < sortUpgradeOper.length; i++) {
        await sortUpgradeOper[i].doUpgrade(this)
      }
      store.version = this.targetVersion
      store.commit()
    } catch (e) {
      logger.info(e)
      store.rollBack()
    }
  }

  private initDao(store: relationalStore.RdbStore) {
    this.dao = [
      new SessionDao(store),
      new ChatHistoryDao(store),
      new ImageCreationHistoryDao(store)
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

  get imageCreationHistoryDao(): ImageCreationHistoryDao {
    if (!this.dao || this.dao.length === 0) {
      throw new Error('DAO数组未初始化');
    }
    const imageCreationHistoryDao = this.dao[2] as ImageCreationHistoryDao;
    if (!imageCreationHistoryDao) {
      throw new Error('ChatHistory DAO不存在');
    }
    return imageCreationHistoryDao;
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

class V2Upgrade implements IRdbUpgrade {
  async doUpgrade(database: AppDataBase): Promise<void> {
    await database.imageCreationHistoryDao.initDao()
  }

  getVersion(): number {
    return 2
  }
}

class V4Upgrade implements IRdbUpgrade {
  async doUpgrade(database: AppDataBase): Promise<void> {
    await database.sessionDao.upgrade1()
  }

  getVersion(): number {
    return 4
  }
}
