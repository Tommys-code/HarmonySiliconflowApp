export class ListDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private list: T[] = [];

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): T {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange([{ type: DataOperationType.RELOAD }]);
    })
  }

  notifyDatasetChange(operations: DataOperation[]): void {
    this.listeners.forEach(listener => {
      listener.onDatasetChange(operations);
    })
  }

  public setNewData(data: Array<T>) {
    let oldLength = this.list.length
    this.list.splice(0, this.list.length);
    this.list.push(...data)
    this.notifyDatasetChange([
      { type: DataOperationType.DELETE, index: 0, count: oldLength },
      { type: DataOperationType.ADD, index: 0, count: data.length },
      // 这样可以服用以前的数据，比如 setNewData 两次同样的数据，如果不加这个会闪烁
      { type: DataOperationType.RELOAD },
    ])
  }

  public removeAllData() {
    this.notifyDatasetChange([
      { type: DataOperationType.MOVE, index: { from: 0, to: this.totalCount() - 1 } }
    ])
  }
}

export class ListDataSourceDataChange implements DataChangeListener {
  private listDataChange?: () => void;

  constructor(onDataChange?: () => void) {
    this.listDataChange = onDataChange
  }

  onDataReloaded(): void {

  }

  onDataAdded(index: number): void {
    this.listDataChange?.()
  }

  onDataAdd(index: number): void {
    this.listDataChange?.()
  }

  onDataMoved(from: number, to: number): void {
    this.listDataChange?.()
  }

  onDataMove(from: number, to: number): void {
    this.listDataChange?.()
  }

  onDataDeleted(index: number): void {
    this.listDataChange?.()
  }

  onDataDelete(index: number): void {
    this.listDataChange?.()
  }

  onDataChanged(index: number): void {
    this.listDataChange?.()
  }

  onDataChange(index: number): void {
    this.listDataChange?.()
  }

  onDatasetChange(dataOperations: DataOperation[]): void {
    this.listDataChange?.()
  }
}