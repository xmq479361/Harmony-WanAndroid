import WanAndroidService from '../../api/WanAndroidService'
import { ApiResponse } from '../../support/http/AxiosHttp'
import { TreeData, TreeDataItem } from '../../model/TreeData'
import CommonConstants from '../../global/CommonConstants'
import router from '@ohos.router'
import { CommonDataSource } from '../../support/DataSource'
import { PageState } from '../../model/vo/PageState'
import PageStateLayout from '../../component/state/PageStateLayout'


class TreeDataSource extends CommonDataSource<TreeData> {
}

// @Entry
@Component
export default struct TreeTabContent {
  dataSource: TreeDataSource = new TreeDataSource()
  @State pageState: PageState = PageState.Initial

  onPageShow() {
    console.log('pageShow()')
  }

  build() {
    Column() {
      PageStateLayout({pageState: this.pageState, onRetry : this.loadTreeData.bind(this)}) {
        this.TreeDataListBuilder()
      }
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .backgroundColor(CommonConstants.THEME_COLOR_BACKGROUND)

  }

  @Builder
  TreeDataListBuilder() {
    Flex() {
      List({ space: 10 }) {
        LazyForEach(this.dataSource, (treeData: TreeData) => {
          // ForEach(this.treeDataList, (treeData: TreeData, _: number) => {
          ListItem() {
            // ArticleItem({ article: article })
            Column() {
              Text(treeData.name)
                .fontWeight(FontWeight.Bold)
                .fontSize(16)
                .maxLines(1)
              Divider()
                .vertical(false)
                .height(0.5)
                .color(CommonConstants.THEME_COLOR_BACKGROUND)
                .opacity(0.6)
                .margin({ top: 8, bottom: 8 })
              Flex({ wrap: FlexWrap.Wrap }) {
                ForEach(treeData.children, (item: TreeDataItem, _: number) => {
                  Button() {
                    Text(item.name)
                      .fontColor(Color.Gray)
                  }
                  .margin(4)
                  .padding({ left: 10, right: 10 })
                  .borderRadius(16)
                  .height(32)
                  .borderColor('#eee')
                  .backgroundColor('#eee')
                  .onClick(() => this.openArticle(item))
                }, (item: TreeDataItem, _: number) => `${item.id}`)
              }
            }.backgroundColor(Color.White)
            .padding(10)
            .alignItems(HorizontalAlign.Start)
          }
        }, (item: TreeData) => `${item.id}`)
      }
      .cachedCount(5)
    }
    .layoutWeight(1)
    .margin({ top: 10 })
  }

  openArticle(treeDataItem: TreeDataItem) {
    console.log("openDetail:", JSON.stringify(treeDataItem))
    router.pushUrl({
      url: 'pages/TreeDetailPage',
      params: {
        title: treeDataItem.name,
        cid: treeDataItem.id,
      }
    })
      // .then(() => {
      //   // success
      //   console.log("openDetail success")
      // })
      .catch(err => {
        console.error(`pushUrl failed, code is ${err.code}, message is ${err.message}`);
      })
  }

  aboutToAppear() {
    this.loadTreeData();
  }

  async loadTreeData() {
    this.pageState = PageState.Loading
    let response: ApiResponse<TreeData[]> = await WanAndroidService.getTreeList()
    console.log("loadTreeData: ", JSON.stringify(response));
    let treeDataList: TreeData[] = response.data
    for (const treeData of treeDataList) {
      this.dataSource.pushData(treeData)
    }
    this.pageState = PageState.Success

  }
}
