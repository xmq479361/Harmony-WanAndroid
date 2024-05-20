import axios, { AxiosResponse, AxiosError } from '@ohos/axios'
import hilog from '@ohos.hilog'
import Logger from '../utils/Logger'

class BannerVO {
  desc: string
  id: number
  imagePath: string
  isVisible: number
  order: number
  title: string
  type: number
  url: String
}
interface BaseResponse<T> {
  data: T
  errorCode: number
  errorMsg: string
}
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }


  aboutToAppear() {
    this.loadBanner();
  }
  loadBanner() {
    console.log('loadBanner')
    // let resp = await getWanAndroidBanner()
    // LogUtils.info("getBanner", JSON.stringify(resp))
    // .then(resp=> {
    //   LogUtils.info("getBanner", JSON.stringify(resp))
    // })
    // .catch(error=>{
    //   LogUtils.info("getBanner", JSON.stringify(error))
    // })
    // WanAndroidApi.getBanner()
    //   .then((banners: BannerVO[]) => {
    //     // this.banners = banners
    //     // for (var banner in banners) {
    //     //   console.log(banner);
    //     // }
    //     console.log("banner resp")
    //     console.log(JSON.stringify(banners))
    //     // banners.push(...banners)
    //   })// .catch(error=>{
    //     //   console.log(JSON.stringify(error))
    //     // })
    //   .catch((err: AxiosError) => {
    //     console.log('err=>', err)
    //   })
    axios.get<BaseResponse<BannerVO[]>>(
      'https://www.wanandroid.com/banner/json',
      {timeout: 3000}
    ).then((response: AxiosResponse<BaseResponse<BannerVO[]>>) =>{
      console.log("response=>",JSON.stringify( response))
    })
      .catch((err: AxiosError) => {
        console.log('err=>', err)
      })
      .then(()=> {
        // 总是会执行
        console.log('end=>')
      });
    Logger.info('Home', "aboutToAppear()")
  }
}