import Banner from '../Banner'
import ArticleListComponent from '../ArticleListComponent'


@Component
export default struct HomeTabContent {
  tag: string = "HomeTabContent"

  build() {
    Column() {
        // .position({y:160, x:0})
      Banner()
      Column() {
        ArticleListComponent()
      }.layoutWeight(1)
    }
    .justifyContent(FlexAlign.Start)
    .height('100%')
  }
}