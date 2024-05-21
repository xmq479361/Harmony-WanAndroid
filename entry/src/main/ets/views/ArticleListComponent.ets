import WanAndroidService from '../api/WanAndroidService';
import PageList from '../model/ArticleList';
import ArticleVO from '../model/ArticleVO';
import ArticleItemComponent from './ArticleItemComponent';
import {
  PullToRefreshComponent,
  PullToRefreshController,
  PullToRefreshViewModel
} from '../component/ptr/PullToRefreshComponent';
import ListState from '../component/ptr/ListState';
import PageState from '../model/vo/PageState';
import ToastUtils from '../utils/ToastUtils';
import { calculateState } from '../utils/StateUtils';

export class ArticleListConfig {
  static readonly CID_NONE = -1;
}

@Component
export default struct ArticleListComponent {
  @State private pageNo: number = 0;
  @State private pageSize: number = 8;
  @State private articles: ArticleVO[] = []
  @State private pageState: PageState = PageState.Initial
  cid?: number
  controller: PullToRefreshController
  @Provide viewModel: PullToRefreshViewModel = new PullToRefreshViewModel({
    refreshEnable: true,
    loadMoreEnable: true,
  })

  @Builder
  itemBuilder(article: ArticleVO, index: number) {
    ArticleItemComponent({ article: article })
  }

  build() {
    PullToRefreshComponent({
      space: 10,
      data: this.articles,
      onController: (controller) => this.controller = controller,
      onRefresh: this.onRefresh.bind(this),
      onLoadMore: this.onLoadMore.bind(this),
      itemBuilder: this.itemBuilder,
      // listViewBuilder: this.listBuilder
    })
  }

  aboutToAppear() {
    this.loadArticleList()
  }

  onRefresh() {
    this.pageNo = 0
    this.articles.length = 0
    this.loadArticleList()
  }

  onLoadMore() {
    console.log("loadArticle(onLoadMore): ", this.pageNo, this.pageState);
    // if (this.pageSize == this.pageNo) return;
    if (this.pageState == PageState.Loading) return;
    this.loadArticleList()
  }

  async loadArticleList() {
    try {
      this.pageState = PageState.Loading
      let response = await WanAndroidService.getArticleList(this.pageNo++, this.pageSize, this.cid)
      console.log("loadArticle: ", this.pageNo, JSON.stringify(response));
      let newData: PageList<ArticleVO> = response.data
      this.articles.push(...newData.datas)
      let newListState = calculateState(this.pageSize, this.articles, newData)
      console.log("loadArticle response: ", newData?.datas.length, this.pageSize, this.articles?.length, newListState);
      this.controller.refreshCompleted()
      this.controller.setListState(newListState)
      this.pageState = PageState.Success
    } catch (e) {
      console.log("loadArticle error", e)
      // this.pageState = PageState.Failed
      this.controller.setListState(ListState.NoMore)
      ToastUtils.showToast("加载失败" + e)

    }
  }

  // @Builder
  // listBuilder() {
  //   // ArticleListView()
  //   List({ scroller: this.viewModel.scroller }) {
  //     if (this.viewModel.refreshEnable) {
  //       ListItem() {
  //         RefreshHeader()
  //       }
  //     }
  //     ForEach(this.articles, (item: any, index: number) => {
  //       ListItem() {
  //         // this.itemBuilder(item, index)
  //         ArticleItemComponent({ article: item })
  //       }
  //     }, (item: ArticleVO, index: number) => item.title)
  //     if (this.viewModel.loadMoreEnable) {
  //       ListItem() {
  //         LoadMoreFooter()
  //       }
  //     }
  //   }
  //   // .clip(true)
  //   .onReachEnd(() => this.controller.handleReadEnd())
  //   .onTouch((event) => this.controller.handleTouchEvent(event))
  //   // .height(this.controller.contentHeight())
  //   .height(this.viewModel.refreshContentH + this.viewModel.headerHeight)
  //   .offset({ y: this.viewModel.offsetY })
  // }
}

