import { ChatViewModel } from './ChatViewModel';

@ObservedV2
export default class MainViewModel extends ChatViewModel {
  @Trace showSideBar: boolean = false;
  @Trace question: string = ''

  toggleDrawer = () => {
    this.showSideBar = !this.showSideBar
  }

  hideDrawer() {
    this.showSideBar = false
  }

  sendData() {
    super.sendData(this.question)
  }

}