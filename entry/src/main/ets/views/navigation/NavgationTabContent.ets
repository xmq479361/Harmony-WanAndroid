import CommonConstants from '../../global/CommonConstants'
import WanAndroidService from '../../api/WanAndroidService'
import { NavigationItem, NavigationItemDetail } from '../../model/NavigationVO'
import router from '@ohos.router'
import { Resources } from '../../global/Resources'
import { PageState } from '../../model/vo/PageState'
import TitleBar from '../TitleBar'
import PageStateLayout from '../../component/state/PageStateLayout'


@Extend(Text)
function forTabText(isSelected: boolean) {
  .fontColor(isSelected ? '#000' : $r('app.color.fontColor_text1'))
  .backgroundColor(isSelected ? Color.Transparent : $r('app.color.dividerColor'))
}

export enum SearchPageState {
  Initial,
  Loading,
  LoadingMore,
  Success,
  SuccessAndNoMore,
  Failed,
  NoData
}

@Component
export default struct NavigationTabContent {
  @State navigationList: NavigationItem[] = []
  @State navigationDetail: NavigationItemDetail[] = []
  @State /*@Watch("onFocusChanged") */focusIndex: number = 0;
  @State navContentHeight: number = 0;
  @State pageState: PageState = PageState.Initial
  scroller: Scroller = new Scroller()

  async onFocusChanged(value: number) {
    console.log("onFocusChanged",value)
    if (value == this.focusIndex) return;
    this.focusIndex = value
    this.navigationDetail = this.navigationList[value].articles
  }

  @Builder
  NavigationContent() {
    Row() {
      Flex() {
        List({ space: 0 }) {
          ForEach(this.navigationList, (navData: NavigationItem, index: number) => {
            ListItem() {
              Text(navData.name)
                .textAlign(TextAlign.Center)
                .forTabText(this.focusIndex == index)
                .fontSize(14)
                .maxLines(1)
                .width('100%')
                .height(50)
                .onClick(() => this.onFocusChanged(index) )
            }
          }, (item: NavigationItem, _: number) => `${item.cid}`)
        }
        .cachedCount(0)
        .edgeEffect(EdgeEffect.None)
        .width('100%')
        .layoutWeight(1)
      }
      .width('25%')


      Flex({ direction: FlexDirection.Column, alignContent: FlexAlign.Center }) {
        Grid(this.scroller) {
          ForEach(this.navigationDetail, (item: NavigationItemDetail, _: number) => {
            GridItem() {
              Text(item.title)
                .textAlign(TextAlign.Center)
                .fontSize(12)
                .maxLines(1)
                .height('100%')
                .fontColor($r('app.color.fontColor_text3'))
            }
            .height('180vp')
            .backgroundColor($r('app.color.dividerColor'))
            .onClick(() => this.openArticle(item))
          }, (item: NavigationItemDetail, _: number) => `${item.id}`)
        }
        .cachedCount(2)
        .columnsTemplate('1fr 1fr')
        .padding('8vp')
        .columnsGap('8vp')
        .rowsGap('8vp')
        .layoutWeight(1)

      }
      .layoutWeight(1)
    }
    .alignItems(VerticalAlign.Top)
    .layoutWeight(1)
  }

  @Builder
  TopSearchBarBuilder() {
    TitleBar() {
      Text("请输入关键字查询, 如: Android")
        .fontColor($r('app.color.fontColor_text1'))
        .fontSize(CommonConstants.DEFAULT_14)
        // .placeholderFont({ size: CommonConstants.DEFAULT_14 })
        .padding({left: 10, right: 10})
        .defaultFocus(false)
        .focusOnTouch(true)
        .borderRadius(20)
        .borderColor(Color.White)
        .backgroundColor(Color.White)
        .layoutWeight(1)
        .height(36)
        .margin({ right: 12 })
        .onClick(() => router.pushUrl({ url: 'pages/SearchPage' }))
      Image(Resources.icon_home_search)
        .width(20)
        .height(20)
    }
  }
  build() {
    Column() {
      // 顶部搜索拦
      this.TopSearchBarBuilder()

      PageStateLayout({pageState: this.pageState, onRetry : this.getNavigationList.bind(this)}) {
        this.NavigationContent()
      }
      // if (this.pageState == PageState.Success) {
      //   this.NavigationContent()
      // } else if (this.pageState == PageState.Empty) {
      //   this.NavigationContent()
      // } else if (this.pageState == PageState.Failed) {
      //     Column() {
      //       Text("加载失败，请检查网络后点击重试。。。")
      //         .onClick(this.getNavigationList.bind(this))
      //     }
      //     .justifyContent(FlexAlign.Center)
      //     .layoutWeight(1)
      // } else if (this.pageState == PageState.Loading) {
      //   Column() {
      //     Progress({
      //       type: ProgressType.Ring,
      //       value: 0
      //     }).width(30).height(30)
      //     Text("加载中。。。").onClick(this.getNavigationList.bind(this))
      //   }
      //   .justifyContent(FlexAlign.Center)
      //   .layoutWeight(1)
      // }
    }
    .justifyContent(FlexAlign.Start)
  }

  openArticle(navItem: NavigationItemDetail) {
    console.log("openDetail:", JSON.stringify(navItem))
    router.pushUrl({
      url: 'pages/WebViewPage',
      params: {
        title: navItem.title,
        link: navItem.link,
      }
    })
    //   .then(() => {
    //     // success
    //     console.log("openDetail success")
    //   })
    //   .catch(err => {
    //     console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
    //   })
  }

  aboutToAppear() {
    this.getNavigationList();
  }

  async getNavigationList() {
    this.pageState = PageState.Loading
    try {
      let response = await WanAndroidService.getNavigationList()
      console.log("getNavigationList: ", JSON.stringify(response));
      this.navigationList = response.data
      this.navigationDetail = this.navigationList[this.focusIndex].articles
      this.pageState = PageState.Success
    } catch (e) {
      console.log("getNavigationList error", e)
      this.pageState = PageState.Failed
    }
  }
}