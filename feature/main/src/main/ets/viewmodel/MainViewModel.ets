import { Session } from 'common/src/main/ets/db/entity/Session';
import { ChatViewModel } from './ChatViewModel';

@ObservedV2
export default class MainViewModel extends ChatViewModel {
  @Trace showSideBar: boolean = false;
  @Trace question: string = ''
  @Trace multiSelect: boolean = false
  @Trace selectedItem: Session[] = []
  toggleDrawer = () => {
    this.showSideBar = !this.showSideBar
    this.multiSelect = false
  }
  toggleMultiSelected = () => {
    this.multiSelect = !this.multiSelect
    this.selectedItem = []
  }

  hideDrawer() {
    this.showSideBar = false
  }

  sendData() {
    super.sendData(this.question)
    this.question = ''
  }

  newChat(sessionID: number | null = null): void {
    super.changeSession(sessionID)
    this.hideDrawer()
  }

  selected(session: Session) {
    if (this.selectedItem.includes(session)) {
      this.selectedItem = this.selectedItem.filter(item => item.id != session.id)
    } else {
      this.selectedItem.push(session)
    }
  }

  selectedAllClick() {
    if (this.selectedItem.length == this.sessionList.length) {
      this.selectedItem = []
    } else {
      this.selectedItem = this.sessionList
    }
  }

  async batchDelete(): Promise<boolean> {
    const result = super.batchDelete(this.selectedItem.map((value) => value.id!!))
    this.toggleMultiSelected()
    return result
  }
}