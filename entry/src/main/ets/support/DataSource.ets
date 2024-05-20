
export class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  public clearData() {
    this.originDataArray.splice(0, this.originDataArray.length);
    console.log("clearData: ", this.originDataArray.length)
    this.notifyDataReload()
  }
  // 该方法为框架侧调用，为LazyForEach组件向其数据源处添加listener监听
  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  // 该方法为框架侧调用，为对应的LazyForEach组件在数据源处去除listener监听
  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }
}
export  abstract class CommonDataSource<T> extends BasicDataSource<T> {
  dataArray: T[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): T {
    return this.dataArray[index]
  }
  public addData(index: number, data: T): void {
    this.dataArray.splice(index, 0, data);
    super.notifyDataAdd(index);
  }
  public clearData() {
    this.dataArray.splice(0, this.dataArray.length);
    console.log("clearData: ", this.dataArray.length)
    super.notifyDataReload()
  }
  public pushData(data: T): void {
    this.dataArray.push(data);
    super.notifyDataAdd(this.dataArray.length - 1);
  }
  // public pushDataArray(data: T[]): void {
  //   // this.dataArray.push(...data);
  //   console.log("push: ", JSON.stringify(data))
  //   for (let item of data) {
  //     this.pushData(item)
  //   }
  //   // let fromIndex = this.totalCount()
  //   // this.dataArray.concat(data);
  //   // super.notifyDataAdd()
  //   // super.notifyDataAdd(this.dataArray.length - 1);
  // }
}