import { ChatHistoryDao, ChatHistoryDaoImpl } from "./ChatHistoryDao";
import { DataBase } from "./DataBase";
import { ImageCreationHistoryDao, ImageCreationHistoryDaoImpl } from "./ImageCreationHistoryDao";
import { SessionDao, SessionDaoImpl } from "./SessionDao";

export class AppDataBase {
  private static instance: AppDataBase
  private database: DataBase
  private sessionDaoImpl?: SessionDaoImpl
  private chatHistoryDaoImpl?: ChatHistoryDaoImpl
  private imageCreationHistoryDaoImpl?: ImageCreationHistoryDaoImpl

  private constructor(context: Context) {
    this.database = new DataBase(context)
    this.database.sessionDao.then(dao => this.sessionDaoImpl = new SessionDao(dao))
    this.database.chatHistoryDao.then(dao => this.chatHistoryDaoImpl = new ChatHistoryDao(dao))
    this.database.imageCreationHistoryDao.then(dao => this.imageCreationHistoryDaoImpl = new ImageCreationHistoryDao(dao))
  }

  get sessionDao(): SessionDaoImpl {
    if (!this.sessionDaoImpl) {
      throw new Error('Session DAO不存在');
    }
    return this.sessionDaoImpl
  }

  get chatHistoryDao(): ChatHistoryDaoImpl {
    if (!this.chatHistoryDaoImpl) {
      throw new Error('ChatHistory DAO不存在');
    }
    return this.chatHistoryDaoImpl
  }

  get imageCreationHistoryDao(): ImageCreationHistoryDaoImpl {
    if (!this.imageCreationHistoryDaoImpl) {
      throw new Error('ImageCreationHistory DAO不存在');
    }
    return this.imageCreationHistoryDaoImpl
  }

  static createAppDataBase(context: Context) {
    if (!AppDataBase.instance) {
      AppDataBase.instance = new AppDataBase(context);
    }
    return AppDataBase.instance;
  }

  static getInstance(): AppDataBase {
    if (!AppDataBase.instance) {
      console.error(`must createAppDataBase first`);
      throw Error(`must createAppDataBase first`);
    }
    return AppDataBase.instance
  }
}