export abstract class BaseDao {
  private observer?: (() => void)

  addObserver(callback: () => void) {
    this.observer = callback
  }

  removeObserver() {
    this.observer = undefined
  }

  dataChange() {
    this.observer?.()
  }
}