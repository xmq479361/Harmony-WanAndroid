import router from '@ohos.router';
import WanAndroidService from '../../api/WanAndroidService';
import ListState from '../../component/ptr/ListState';
import {
  PullToRefreshComponent,
  PullToRefreshController,
  PullToRefreshViewModel
} from '../../component/ptr/PullToRefreshComponent';
import CommonConstants from '../../global/CommonConstants';
import PageList from '../../model/ArticleList';
import { ProjectItemSub } from '../../model/ProjectVO';
import PageState from '../../model/vo/PageState';
import { calculateState } from '../../utils/StateUtils';

@Extend(Text)
function descText() {
  .fontSize(CommonConstants.FONT_SIZE_SMALL_MORE)
  .fontColor($r('app.color.fontColor_text1'))
}

@Component
struct ProjectSubItemComponent {
  item: ProjectItemSub;

  build() {
    Row({ space: CommonConstants.DEFAULT_10 }) {
      Image(this.item.envelopePic).width('90vp')
      Column({ space: CommonConstants.DEFAULT_10 }) {
        Text(this.item.title).fontSize(CommonConstants.FONT_SIZE_NORMAL_X).maxLines(2)
          .fontColor($r('app.color.fontColor_text3'))
        Text(this.item.desc).descText().maxLines(6)
        Row() {
          Text(this.item.author).descText()
          Text(this.item.niceDate).descText()
        }
        .layoutWeight(1)
        .alignItems(VerticalAlign.Bottom)
        .width(CommonConstants.THOUSANDTH_1000)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .layoutWeight(1)
      .padding(CommonConstants.DEFAULT_10)
      .justifyContent(FlexAlign.Start)
      .alignItems(HorizontalAlign.Start)
    }
    .alignItems(VerticalAlign.Center)
    .padding(CommonConstants.DEFAULT_10)
    .height('200vp')
    .width(CommonConstants.THOUSANDTH_1000)
    .backgroundColor(Color.White)
    .onClick(this.openWebView.bind(this))
  }

  openWebView() {
    console.log("openWebView", JSON.stringify(this.item))
    router.pushUrl({
      url: 'pages/WebViewPage',
      params: {
        title: this.item.title,
        link: this.item.link,
      }
    })
  }
}

@Component
export default struct ProjectSubList {
  @State pageNo: number = 0;
  @State pageSize: number = 8;
  @State pageState: PageState = PageState.Initial;
  @State projectItems: ProjectItemSub[] = [];
  controller?: PullToRefreshController
  cid: number;
  @Provide viewModel: PullToRefreshViewModel = new PullToRefreshViewModel({
    refreshEnable: true,
    loadMoreEnable: true,
  })

  @Builder
  itemBuilder(item: ProjectItemSub, _: number) {
    ProjectSubItemComponent({ item: item })
  }

  build() {
    Column() {
      PullToRefreshComponent({
        space: CommonConstants.DEFAULT_10,
        onController: (controller) => this.controller = controller,
        onRefresh: this.onRefresh.bind(this),
        onLoadMore: this.onLoadMore.bind(this),
        data: this.projectItems,
        itemBuilder: this.itemBuilder
      })
    }
    .layoutWeight(1)
    .width(CommonConstants.THOUSANDTH_1000)
  }
  aboutToAppear() {
    this.onRefresh()
  }

  async loadProjectSubItems() {
    this.pageState = PageState.Loading
    try {
      if (this.pageNo > 0) {
        this.controller.setListState(ListState.Loading)
      }
      let response = await WanAndroidService.getProjectItemList(this.pageNo++, this.pageSize, this.cid)
      console.log("loadProjectSubItems: ", JSON.stringify(response));
      let newData: PageList<ProjectItemSub> = response.data
      this.projectItems.push(...newData.datas)
      let newListState = calculateState(this.pageSize, this.projectItems, newData)
      console.log("subItem response: ", newData?.datas.length, this.pageSize, this.projectItems?.length, newListState);
      this.controller.refreshCompleted()
      this.controller.setListState(newListState)
      this.pageState = PageState.Success
    } catch (e) {
      console.log("loadProjectSubItems error", e)
      this.pageState = PageState.Failed
    }
  }

  onLoadMore() {
    console.log("ProjectSub loadMore")
    this.loadProjectSubItems()
  }
  onRefresh() {
    this.pageNo = 0
    this.projectItems.length = 0
    this.loadProjectSubItems()
  }
}
