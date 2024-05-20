import router from '@ohos.router';
import WanAndroidService from '../api/WanAndroidService';
import CommonConstants from '../global/CommonConstants';
import HotKey from '../model/SearchVO';
import ArticleList from '../model/ArticleList';
import ArticleVO from '../model/ArticleVO';
import { CommonDataSource } from '../support/DataSource';
import { Resources } from '../global/Resources';


// function removeHtmlNode(content: string) {
//  const regex = /(<([^>] )>)/ig
//   return content.replace(regex, '')
// }
function filterHTMLTag(msg) {
  var msg = msg.replace(/<\/?[^>]*>/g, ''); //去除HTML Tag
  msg = msg.replace(/[|]*\n/, '去除行尾空格') //去除行尾空格
  msg = msg.replace(/ /ig, ''); //去掉npsp
  msg = msg.replace('&gt;', '>'); //去掉npsp
  msg = msg.replace('&lt;', '<'); //去掉npsp

  return msg;
}


@Component
struct HotSearchComponent {
  @Prop hotKeys: HotKey[] = []
  changeKey?: (string) => void = this.defaultChangeKey

  defaultChangeKey() {
  }

  build() {
    Column({ space: CommonConstants.DEFAULT_10 }) {
      Text('热门搜索')
        .textAlign(TextAlign.Start)
        .fontColor(Color.Gray)
        .fontSize(12)
        .margin({ top: CommonConstants.DEFAULT_10 })
      Grid() {
        ForEach(this.hotKeys, (item: HotKey, _: number) => {
          GridItem() {
            Text(item.name)
              .fontSize(14)
              .maxLines(1)
              .width('100%')
              .height(36)
              .onClick(() => this.changeKey(item.name))
            // .onClick(() => this.searchKey = item.name)
          }
        }, (item: HotKey, _: number) => `${item.id}`)
      }
      .columnsTemplate('1fr 1fr')
      .rowsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr 1fr')
      .columnsGap(12)
      .rowsGap(20)
      .width('100%')
      .height(270)
    }
    .width(CommonConstants.THOUSANDTH_940)
    .alignItems(HorizontalAlign.Start)
  }
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

class SearchArticleDataSource extends CommonDataSource<ArticleVO> {
}

@Entry
@Component
struct SearchPage {
  @State uiSearchKey: string = ''
  @State realSearchKey: string = ''
  @State pageNo: number = 0
  @State pageState: SearchPageState = SearchPageState.Initial
  @State hotKeys: HotKey[] = []
  private dataSource: SearchArticleDataSource = new SearchArticleDataSource();

  aboutToAppear() {
    if (this.hotKeys.length == 0) {
      this.loadHotKey();
    }
  }

  async loadHotKey() {
    let response = await WanAndroidService.getHotKey()
    console.log("loadHotKey: ", JSON.stringify(response));
    this.hotKeys = response.data
  }

  build() {
    Column() {
      Row({ space: CommonConstants.DEFAULT_10 }) {
        Image(Resources.icon_back)
          .onClick(() => router.back())
          .height(20).width(20)
        Search({ value: this.uiSearchKey,
          placeholder: "请输入关键字搜索, 如: Android" })
          .onChange((value) => this.onSearchKeyChanged(value))
          .searchButton('搜索')
          .onSubmit((string) => this.performSearch(string))
          .textFont({ size: CommonConstants.DEFAULT_14 })
          .placeholderFont({ size: CommonConstants.DEFAULT_14 })
          .backgroundColor(Color.White)
          .placeholderColor($r('app.color.fontColor_text1'))
          .layoutWeight(1)
      }
      .width(CommonConstants.THOUSANDTH_940)

      Divider().height(0.4).color($r('app.color.lightest_gray'))
      Column() {
        if (this.pageState == SearchPageState.Success
          || this.pageState == SearchPageState.SuccessAndNoMore
          || this.pageState == SearchPageState.LoadingMore) {
          this.ResultListBuilder()
        } else if (this.pageState == SearchPageState.NoData) {
          Column() {
            Image(Resources.icon_home_cart).width(30).height(30)
            Text("搜索不到。。。")
          }.justifyContent(FlexAlign.Center)
          .height(CommonConstants.THOUSANDTH_800)
        } else if (this.pageState == SearchPageState.Loading) {
          Column() {
            Progress({
              type: ProgressType.Ring,
              value: 0
            }).width(30).height(30)
            Text("搜索中。。。")
          }.justifyContent(FlexAlign.Center)
          .height(CommonConstants.THOUSANDTH_800)
        } else if (this.pageState == SearchPageState.Failed) {
          Column() {
            Text("搜索失败，请检查网络后点击重试。。。")
              .onClick(() => this.doSearch(this.realSearchKey))
          }.justifyContent(FlexAlign.Center)
          .height(CommonConstants.THOUSANDTH_1000)
        } else {
          HotSearchComponent({ hotKeys: this.hotKeys, changeKey: this.onSearchKeyChanged.bind(this) })
        }
      }
      .layoutWeight(1)
    }
    .height(CommonConstants.THOUSANDTH_1000)
    .backgroundColor($r('app.color.light_color'))
  }

  @Builder
  ResultListBuilder() {
    // Flex() {
    List({ space: 3 }) {
      LazyForEach(this.dataSource, (item: ArticleVO) => {
        ListItem() {
          Text(item.title)
            .onClick(() => this.openWebView(item))
            .height(60)
            .width('100%')
            .backgroundColor(Color.White)
            .padding(10)
        }
      }, (item: ArticleVO) => `${item.id}`)
    }
    .cachedCount(5)
    .onReachEnd(() => {
      if (!this.canAutoLoadMore()) return;
      console.log("onReachEnd", this.pageState)
      this.doSearch(this.realSearchKey)
    })
    .layoutWeight(1)
  }

  canAutoLoadMore() {
    if (this.pageState == SearchPageState.Loading
      || this.pageState == SearchPageState.LoadingMore
      || this.pageState == SearchPageState.NoData
      || this.pageState == SearchPageState.SuccessAndNoMore
    ) {
      return false
    }
    return true;
  }

  @State searchHandleId: number = 0;

  onSearchKeyChanged(key: string) {
    this.uiSearchKey = key
    console.log("searchByKey", key)
    if (key.length == 0) {
      this.dataSource.clearData()
      clearTimeout(this.searchHandleId)
      this.pageState = SearchPageState.Initial
    }
  }

  performSearch(key) {
    let searchHandleId = setTimeout(() => {
      console.log("doSearch", key)
      if (key != this.uiSearchKey) {
        clearTimeout(this.searchHandleId)
        console.log("doSearch(Conflict): ", searchHandleId, key, this.uiSearchKey);
        return;
      }
      this.searchHandleId = searchHandleId
      this.doSearch(key)
    }, 300)
  }

  async doSearch(currentKey: string) {
    try {
      if (currentKey != this.realSearchKey) {
        this.pageNo = 0;
        this.dataSource.clearData()
        this.realSearchKey = currentKey;
      }
      const isFirstPage = this.pageNo == 0;
      if (isFirstPage) {
        this.pageState = SearchPageState.Loading
      } else {
        this.pageState = SearchPageState.LoadingMore
      }
      let response = await WanAndroidService.search(this.pageNo++, this.realSearchKey)
      console.log("doSearch: ", currentKey, JSON.stringify(response));
      if (currentKey != this.realSearchKey) {
        console.log("doSearch(Conflict): ", currentKey, this.realSearchKey);
        return;
      }
      let articles: ArticleList = response.data
      if (articles.datas.length == 0) {
        console.log("doSearch(Empty): ", currentKey, isFirstPage);
        if (isFirstPage) {
          this.pageState = SearchPageState.NoData
        } else {
          this.pageState = SearchPageState.SuccessAndNoMore
        }
        return;
      }
      for (const item of articles.datas) {
        console.log("item: ", item.title);
        item.title = filterHTMLTag(item.title)
        this.dataSource.pushData(item)
      }
      console.log("doSearch Success: ", articles.datas.length, this.pageState);
      if (articles.datas.length > 10) {
        this.pageState = SearchPageState.Success
      } else {
        this.pageState = SearchPageState.SuccessAndNoMore
      }
    } catch (e) {
      console.log("searchByKey error", e)
      this.pageState = SearchPageState.Failed
    }
  }

  openWebView(article: ArticleVO) {
    router.pushUrl({
      url: 'pages/WebViewPage',
      params: {
        title: article.title,
        link: article.link,
      }
    })
      .then(() => {
        // success
      })
      .catch(err => {
        console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
      })
  }
}