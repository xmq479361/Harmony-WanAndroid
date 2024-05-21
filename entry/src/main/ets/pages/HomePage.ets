import router from '@ohos.router'
import HomeTabContent from '../views/home/HomeTabContent'
import MeTabContent from '../views/me/MeTabContent'
import NavigationTabContent from '../views/navigation/NavgationTabContent'
import {
  PullToRefreshComponent,
  PullToRefreshController,
  PullToRefreshViewModel
} from '../component/ptr/PullToRefreshComponent'
import ListState from '../component/ptr/ListState'
import TreeTabContent from '../views/tree/TreeTabContent'
import CommonConstants from '../global/CommonConstants'
import { Resources } from '../global/Resources'
import ProjectTabContent from '../views/project/ProjectTabContent'

@Extend(Text)
function forTabText(isSelected: boolean) {
  .textAlign(TextAlign.End)
  .fontSize(isSelected ? 14 : 11)
  .fontColor(isSelected ? $r('app.color.lightest_primary_color') : $r('app.color.fontColor_text1'))
}

const colorFilterNormal =
  [0.1, 0, 0, 0, 0,
    0, 0.1, 0, 0, 0,
    0, 0, 0.1, 0, 0,
    0, 0, , 0, 1, 0]

const colorFilterSelected =
  [0.27, 0, 0, 0, 0,
    0, 0.67, 0, 0, 0,
    0, 0, 0.53, 0, 0,
    0, 0, 0, 1, 0]

// FF46AC88

@Extend(Image)
function forTabIcon(isSelected: boolean) {
  .colorFilter(isSelected ? colorFilterSelected : colorFilterNormal)
  // .fillColor(isSelected ? Color.Yellow: Color.Red)
  .width(20)
  .layoutWeight(1)
}

@Component
export struct PullToRefreshTabContent {
  @State data: string[] = []
  controller?: PullToRefreshController
  @Provide viewModel: PullToRefreshViewModel = new PullToRefreshViewModel({
    refreshEnable: false,
    loadMoreEnable: true
  })

  aboutToAppear() {
    for (let i = 0; i <= 20; i++) {
      this.data.push('item' + i)
    }
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
    .justifyContent(FlexAlign.Start)
    .height(CommonConstants.THOUSANDTH_1000)
    .backgroundColor(CommonConstants.THEME_COLOR_BACKGROUND)
  }

  @Builder
  itemBuilder(item: string, index: number) {
    Row() {
      Text(item)
        .height(60)
        .width('100%')
        .padding(10)
        .backgroundColor(Color.Orange)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/PullToRefreshPage2'
          })
        })
    }
    .width(CommonConstants.THOUSANDTH_1000)
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

@Entry
@Component
struct HomePage {
  private controller: TabsController = new TabsController()
  @State currentIndex: number = 0
  @State active: number[] = [this.currentIndex]

  aboutToAppear() {
    console.log("Home aboutToAppear")
  }

  onPageShow() {
    console.log("Home onPageShow")
  }

  @Builder
  TabBuilder(index: number, title: string, icon: Resource) {
    Column() {
      if (index == this.currentIndex) {
        Image(icon)
          .objectFit(ImageFit.Contain)
          .colorFilter(colorFilterSelected)
          .width(20)
          .layoutWeight(1)
      } else {
        Image(icon)
          .renderMode(ImageRenderMode.Template)
          .objectFit(ImageFit.Contain)
          .colorFilter(colorFilterNormal)
          .width(20)
          .layoutWeight(1)
      }
      Text(title)
        .forTabText(index == this.currentIndex)
    }
    .justifyContent(FlexAlign.Center)
    .padding(5)
    .height(50)
    .width(CommonConstants.THOUSANDTH_900)
  }

  build() {
    Tabs({ barPosition: BarPosition.End, controller: this.controller, index: this.currentIndex }) {
      ForEach([
        { title: "首页", icon: Resources.icon_home_pager_not_selected },
        { title: "项目", icon: Resources.icon_project_not_selected },
        { title: "导航", icon: Resources.icon_navigation_not_selected },
        { title: "体系", icon: Resources.icon_knowledge_hierarchy_not_selected },
        { title: "我的", icon: $r('app.media.mine') }], (item, index) => {
        TabContent() {
          if (this.active.includes(index)) {
            if (index == 0) {
              HomeTabContent()
            } else if (index == 1) {
              ProjectTabContent()
            } else if (index == 2) {
              NavigationTabContent()
            } else if (index == 3) {
              TreeTabContent()
            } else if (index == 4) {
              MeTabContent()
            }
          }
        }.tabBar(this.TabBuilder(index, item.title, item.icon))
      })
    }
    .scrollable(false)
    .barHeight(56)
    .barMode(BarMode.Fixed)
    .vertical(false)
    .onChange((index: number) => {
      if (!this.active.includes(index)) {
        this.active.push(index)
      }
      this.currentIndex = index
    })
    .height(CommonConstants.THOUSANDTH_1000)
    .backgroundColor(CommonConstants.THEME_COLOR_BACKGROUND)
  }
}

