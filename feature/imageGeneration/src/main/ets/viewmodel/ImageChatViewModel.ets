import {
  AppDataBase,
  createImageGenerationsRequest,
  ImageCreationOptions,
  SettingDataStore,
  SiliconFlowService,
  UserInfoStore,
  ResourceType,
  Loading,
  ListDataSource,
  Success,
  Failed
} from "common";
import { ImageGenerationsResponse } from "common/src/main/ets/models/ImageGenerationsResponse";
import { BusinessError } from "@kit.BasicServicesKit";
import { ImageCreationHistory } from "common/src/main/ets/db/entity/ImageCreationHistory";
import { SessionType } from "common/src/main/ets/db/entity/Session";

@ObservedV2
export class ImageChatViewModel {
  @Trace private currentSessionID?: number = undefined
  private appDataBase = AppDataBase.getInstance()!!
  private userInfoStore = UserInfoStore.getInstance()
  @Trace imageOptions: ImageCreationOptions = SettingDataStore.getInstance().imageCreationOptions
  @Trace data?: ResourceType<ImageGenerationsResponse> = undefined
  history: ListDataSource<ImageCreationHistory> = new ListDataSource()

  @Monitor("currentSessionID")
  currentSessionIDChange(monitor: IMonitor) {
    if (monitor.value()?.now != monitor.value()?.before) {
      this.onHistoryChange(monitor.value<number>()?.now)
    }
  }

  constructor(sessionID?: number) {
    this.currentSessionID = sessionID
    this.onHistoryChange(sessionID)
  }

  private onHistoryChange(sessionID?: number) {
    if (sessionID) {
      this.appDataBase.imageCreationHistoryDao.offDataChange()
      this.appDataBase.imageCreationHistoryDao.onDataChange(sessionID, (data) => {
        this.history.setNewData(data)
      })
    } else {
      this.history.setNewData([])
    }
  }

  createImage(prompt: string) {
    this.insertSendData(prompt).then((id) => {
      this.data = Loading.Progress
      // SiliconFlowService.imageGenerations(createImageGenerationsRequest(prompt, this.imageOptions)).then((value) => {
      //   this.data = new Success(value)
      //   this.appDataBase.imageCreationHistoryDao.update(value, id)
      // }).catch((e: BusinessError) => {
      //   this.data = new Failed(e)
      // })
    })
  }

  private async insertSendData(prompt: string) {
    const id =
      this.currentSessionID ??
        await this.appDataBase.sessionDao.insert(prompt, SessionType.IMAGE, this.userInfoStore.userInfo?.id)
    const data: ImageCreationHistory = new ImageCreationHistory()
    data.sessionId = id
    data.prompt = prompt
    data.ratio = this.imageOptions.ratio
    data.batchSize = this.imageOptions.batchSize
    this.currentSessionID = id
    return await this.appDataBase.imageCreationHistoryDao.insert(data)
  }
}