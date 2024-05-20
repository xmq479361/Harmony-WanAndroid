import CommonConstants from '../global/CommonConstants'
import WanAndroidService from '../api/WanAndroidService'
import { NavigationItem, NavigationItemDetail } from '../model/NavigationVO'
import router from '@ohos.router'
import { Resources } from '../global/Resources'


@Extend(Text)
function forTabText(isSelected: boolean) {
  // .fontColor(isSelected ? '#000' : "#888")
  // .backgroundColor(isSelected ? Color.Transparent : '#EEE')
  .fontColor(isSelected ? '#000' : $r('app.color.fontColor_text1'))
  .backgroundColor(isSelected ? Color.Transparent : $r('app.color.listColor'))
}

@Component
struct SearchBarComponent {
  @State searchKey: string = ''

  // @BuilderParam contentBuilder: () => void = this.defaultCtBuilder

  // @Builder
  // defaultCtBuilder() {
  //   Text('默认文本')
  // }

  build() {
    // Column() {
    Row({ space: CommonConstants.DEFAULT_10 }) {
      Text("请输入关键字查询, 如: Android")
        .fontColor($r('app.color.fontColor_text1'))
        .padding(10)
        .defaultFocus(false)
        .focusOnTouch(true)
        .borderRadius(20)
        .borderColor(Color.White)
        .backgroundColor(Color.White)
        .layoutWeight(1)
        .height(40)
        .margin({ right: 12 })
        .onClick(() => router.pushUrl({ url: 'pages/SearchPage' }))

      Image(Resources.icon_home_search)
        .width(24)
        .height(24)
    }
    .alignItems(VerticalAlign.Center)
    .width(CommonConstants.THOUSANDTH_940)
    .padding(10)

    //   this.contentBuilder()
    // }
    // .height('100%')
    .backgroundColor($r('app.color.listColor'))
  }
}

@Entry
@Component
struct NavigationTabContent {
  @State navigationList: NavigationItem[] = []
  @State focusIndex: number = 0;
  @State navContentHeight: number = 0;
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      SearchBarComponent()
      if (this.navigationList.length > 0) {
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
                    .onClick(() => this.focusIndex = index)
                }
              }, (item: NavigationItem, _: number) => `${item.cid}`)
            }
            .width('100%')
            .layoutWeight(1)
          }
          .width('25%')


          Flex({ direction: FlexDirection.Column, alignContent: FlexAlign.Center }) {
            Grid(this.scroller) {
              // ForEach(navData.articles, (item: NavigationItemDetail, index: number) => {
              ForEach(this.navigationList[this.focusIndex].articles, (item: NavigationItemDetail, index: number) => {
                GridItem() {
                  Text(item.title)
                    .textAlign(TextAlign.Center)
                    .fontSize(12)
                    .maxLines(1)
                    .height('100%')
                    .fontColor($r('app.color.fontColor_text3'))
                    .onClick(() => this.openArticle(item))
                }
                // .height('50%')
                .height('180vp')
                .backgroundColor('#EEE')
              }, (item: NavigationItemDetail, _: number) => `${item.id}`)
            }
            .columnsTemplate('1fr 1fr')
            // .layoutDirection(GridDirection.Column)
            .padding(10)
            .columnsGap('8vp')
            .rowsGap('12vp')
            .layoutWeight(1)

          }
          // .backgroundColor(Color.Red)
          .layoutWeight(1)
        }
        .alignItems(VerticalAlign.Top)
        .layoutWeight(1)
      }
    }
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
    let response = await WanAndroidService.getNavigationList()
    console.log("loadTreeData: ", JSON.stringify(response));
    this.navigationList = response.data
  }
}