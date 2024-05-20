import WanAndroidService from '../api/WanAndroidService'
import CommonConstants from '../global/CommonConstants'
import BannerVO from '../model/BannerVO'
import Logger from '../utils/Logger'

@Component
export default struct Banner {
  @State bannerSource: BannerVO[] = []

  build() {
    if (this.bannerSource.length == 0) {
      Row()
        .height(160)
        .width(CommonConstants.THOUSANDTH_900)
    } else {
      Swiper() {
        ForEach(this.bannerSource, (item: BannerVO, index: number) => {
          Image(`${item.imagePath}`)
            .width(CommonConstants.THOUSANDTH_900)
            .height(160)
        }, (item: BannerVO) => item.desc)
      }
      .cachedCount(2)
      .index(1)
      .autoPlay(true)
      .interval(3000)
      .indicator(true)
      .loop(true)
      .duration(800)
      .itemSpace(0)
      .curve(Curve.Linear)
      .padding(2)
      .width(CommonConstants.THOUSANDTH_1000)
    }
  }

  aboutToAppear() {
    this.loadBanner();
  }

  async loadBanner() {
    console.log('loadBanner')
    let resp = await WanAndroidService.getWanAndroidBanner()
    let banners: BannerVO[] = resp.data
    Logger.info("getBanner", "banners: " + banners.length)
    this.bannerSource = banners
  }
}