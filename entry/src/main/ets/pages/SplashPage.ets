import router from '@ohos.router'

@Entry
@Component
struct SplashPage {
  build() {
    Row() {
      Column() {
        Image($r('app.media.ic_launcher'))
          .width(100)
          .height(100)
        Row() {
          Text("WanAndroid")
            .fontSize(20)
            .fontColor($r('app.color.secondary_color'))
          Text(" By ")
            .fontSize(16)
          Text("Harmony")
            .fontSize(20)
            .fontColor(Color.Green)
            .fontWeight(FontWeight.Bold)
        }
        .margin(15)
      }
      .width('100%')
    }
    .height('100%')
  }

  onPageShow() {
    console.log("Splash onPageShow")
  }
  aboutToAppear() {
    console.log("Splash aboutToAppear")
    setTimeout(() => {
      router.pushUrl({
        url: 'pages/HomePage'
      })
    }, 1000)
  }
}