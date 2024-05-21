import web_webview from '@ohos.web.webview'
import router from '@ohos.router'
import { Resources } from '../global/Resources'
import TitleBar from '../views/TitleBar'
import PageStateLayout from '../component/state/PageStateLayout'
import PageState from '../model/vo/PageState'

@Entry
@Component
struct WebViewPage {
  private controller: web_webview.WebviewController = new web_webview.WebviewController()
  // @State params: Object = router.getParams()
  @State link: string = ''
  @State title: string = ''
  @State blockNetworkResource: boolean = true
  @State pageState: PageState = PageState.Loading

  aboutToAppear() {
    if (router.getParams()) {
      let params : Object = router.getParams()
      this.title = params['title'] ? params['title'] : ""
      this.link = params['link'] ? params['link'] : ""
    } else {
      this.title = '404'
    }

    console.log("WebView load:", this.link)
  }

  build() {

    Column() {
      TitleBar({
        left: { icon: Resources.icon_back },
        center: { str: this.title }
      })
      // Stack() {
      if (this.link) {
        Web({ src: this.link, controller: this.controller })// .blockNetwork(this.blockNetworkResource)
          // .fileAccess(false)
          // .zoomAccess(false)
          // .minFontSize(10)
          // .geolocationAccess(false)// .mixedMode(MixedMode.Compatible)
          //
          // .onHttpErrorReceive((event) => {
          //   console.log('url:' + event.request.getRequestUrl())
          //   console.log('isMainFrame:' + event.request.isMainFrame())
          //   console.log('isRedirect:' + event.request.isRedirect())
          //   console.log('isRequestGesture:' + event.request.isRequestGesture())
          //   console.log('getResponseData:' + event.response.getResponseData())
          //   console.log('getResponseEncoding:' + event.response.getResponseEncoding())
          //   console.log('getResponseMimeType:' + event.response.getResponseMimeType())
          //   console.log('getResponseCode:' + event.response.getResponseCode())
          //   console.log('getReasonMessage:' + event.response.getReasonMessage())
          //   let result = event.request.getRequestHeader()
          //   console.log('The request header result size is ' + result.length)
          //   for (let i of result) {
          //     console.log('The request header key is : ' + i.headerKey + ' , value is : ' + i.headerValue)
          //   }
          //   let resph = event.response.getResponseHeader()
          //   console.log('The response header result size is ' + resph.length)
          //   for (let i of resph) {
          //     console.log('The response header key is : ' + i.headerKey + ' , value is : ' + i.headerValue)
          //   }
          //   this.pageState = PageState.Failed
          // })
          // .onPageBegin((event) => {
          //   this.blockNetworkResource = true
          //   console.log('onPageBegin:' + event)
          //   console.log('url:' + event.url)
          //   this.pageState = PageState.Loading
          // })
          // .onPageEnd((event) => {
          //   this.blockNetworkResource = false
          //   console.log('url:' + event.url)
          // })
          // .onRefreshAccessedHistory((event) => {
          //   console.log('url:' + event.url + ' isReload:' + event.isRefreshed)
          //   this.pageState = PageState.Success
          // })
          // .onRenderExited((event) => {
          //   console.log('reason:' + event.renderExitReason)
          // })
          // .onResourceLoad((event) => {
          //   console.log('onResourceLoad: ' + event.url)
          // })// .onUrlLoadIntercept((event) => {
          //   //   console.log('onUrlLoadIntercept ' + event.data.toString())
          //   //   return true
          //   // })
          // .onSslErrorEventReceive((event) => {
          //   console.log('onSslErrorEventReceive:' + event)
          // })
        // .onInterceptRequest((event) => {
        //   console.log('url:' + event.request.getRequestUrl())
        //   // return super.o
        // })

        //   PageStateLayout({ pageState: this.pageState }) {
        //   }
        // }
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.light_color'))
  }
}