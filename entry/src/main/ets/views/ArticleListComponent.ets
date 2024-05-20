import WanAndroidService from '../api/WanAndroidService';
import ArticleList from '../model/ArticleList';
import ArticleVO from '../model/ArticleVO';
import ArticleItemComponent from './ArticleItemComponent';
import {
  PullToRefreshComponent,
  PullToRefreshController,
  PullToRefreshViewModel} from '../component/ptr/PullToRefreshComponent';
import * as ListState from '../component/ptr/ListState';

export class ArticleListConfig {
  static readonly CID_NONE = -1;
}

@Component
export default struct ArticleListComponent {
  @State private pageNo: number = 0;
  @State private pageCount: number = 5;
  @State private articles: ArticleVO[] = []
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
    this.loadArticleList()
  }

  onLoadMore() {
    if (this.pageCount == this.pageNo) return;
    this.loadArticleList()
  }

  async loadArticleList() {
    let response = await WanAndroidService.getArticleList(this.pageNo++, this.cid)
    console.log("loadArticle: ", this.pageNo, JSON.stringify(response));
    let articleList: ArticleList = response.data
    this.articles.push(...articleList.datas)
    this.controller.refreshCompleted()
    if (articleList.datas?.length > 0 || articleList.total > 0) {
      if (this.pageNo >= articleList.pageCount) {
        this.controller.setListState(ListState.NoMore)
      } else {
        this.controller.setListState(ListState.HasMore)
      }
    } else {
      this.controller.setListState(ListState.NoData)
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

