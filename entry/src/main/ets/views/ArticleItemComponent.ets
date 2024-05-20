import router from '@ohos.router';
import ArticleVO from '../model/ArticleVO'

@Component
export default struct ArticleItemComponent {
  @Prop private article: ArticleVO;

  build() {
    Column() {
      Text(this.article.title)
        .fontSize(16)
        .textAlign(TextAlign.Start)
        .maxLines(1)
        .width('100%')
      Row() {
        if (this.article.author && this.article.author.length > 0) {
          Text(this.article.author)
            .fontColor('#AAA')
            .fontSize(10)
        } else {
          Text(this.article.shareUser)
            .fontColor('#AAA')
            .fontSize(10)
        }
        Text(this.article.niceDate)
          .fontColor('#AAA')
          .fontSize(10)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 20 })
    }
    .padding(10)
    .backgroundColor(Color.White)
    .width('100%')
    .onClick(()=>{
      this.openWebView()
    })
  }

  openWebView() {
    router.pushUrl({
      url: 'pages/WebViewPage',
      params: {
        title: this.article.title,
        link: this.article.link,
        // tt:this.article.author
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