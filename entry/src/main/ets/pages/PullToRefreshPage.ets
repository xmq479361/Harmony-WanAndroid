import { PullToRefreshComponent, PullToRefreshController } from '../component/ptr/PullToRefreshComponent'
import * as ListState from '../component/ptr/ListState'

@Entry
@Component
struct PullToRefreshPage {
  @State data: string[] = []
  controller?: PullToRefreshController

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.push('item' + i)
    }
  }

  @Builder
  itemBuilder(item: string, index: number) {
      Text(item)
        .height(60)
        .width('100%')
        .padding(10)
        .backgroundColor(Color.Orange)
  }

  build() {
    Column() {
      PullToRefreshComponent({
        space: 10,
        onController: (controller) => this.controller = controller,
        onRefresh: this.onRefresh.bind(this),
        onLoadMore: this.onLoadMore.bind(this),
        data: this.data,
        itemBuilder: this.itemBuilder
      })
    }
    .layoutWeight(1)
    .height('100%')
    .backgroundColor(Color.Pink)
  }

  onRefresh() {
    console.log("onRefresh")
    setTimeout(() => {
      this.controller?.refreshCompleted()
    }, 1000)
  }

  onLoadMore() {
    console.log("onLoadmore")
    setTimeout(() => {
      for (let i = 21; i <= 25; i++) {
        this.data.push('item' + i)
      }
      this.controller?.loadMoreCompleted(ListState.NoMore)
    }, 1000)
  }
}