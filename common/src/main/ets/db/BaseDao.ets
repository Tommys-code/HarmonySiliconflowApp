import { relationalStore } from '@kit.ArkData'

export abstract class BaseDao {
  abstract tableName: string
  protected store?: relationalStore.RdbStore

  constructor(store: relationalStore.RdbStore) {
    this.store = store;
    this.initDao(store)
  }

  abstract initDao(store: relationalStore.RdbStore)

  onDataChangeDetail(callback: () => void) {
    if (this.store != undefined) {
      this.store.on('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS,
        async (changeInfo: Array<relationalStore.ChangeInfo>) => {
          if (changeInfo.length > 0) {
            for (let index = 0; index < changeInfo.length; index++) {
              const table = changeInfo[index].table;
              if (table === this.tableName) {
                callback()
                return
              }
            }
          }
        })
    }
  }

  offDataChange() {
    this.store?.off('dataChange', relationalStore.SubscribeType.SUBSCRIBE_TYPE_LOCAL_DETAILS)
  }
}