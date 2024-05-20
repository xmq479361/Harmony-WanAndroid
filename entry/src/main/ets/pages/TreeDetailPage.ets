import router from '@ohos.router'
import ArticleListComponent from '../views/ArticleListComponent'
import TitleBar from '../views/TitleBar'
import CommonConstants from '../global/CommonConstants'


// @Preview
@Entry
@Component
struct TreeDetailPage {
  @State params: Object = router.getParams()
  @State title: string = ''
  @State cid: number = -1
  aboutToAppear() {
    console.log("Detail: ", JSON.stringify(this.params))
    this.title = this.params['title']?this.params['title']:""
    this.cid = this.params['cid']?this.params['cid']:-1

    if (this.params['cid']) {
      this.cid = this.params['cid']
    }
  }
  build() {
    Column() {
      TitleBar({
        // left: {icon: Resources.icon_back},
        center: {str: this.title}
      })
      ArticleListComponent({ cid: this.cid })
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
    .backgroundColor(CommonConstants.THEME_COLOR_BACKGROUND)
  }
}