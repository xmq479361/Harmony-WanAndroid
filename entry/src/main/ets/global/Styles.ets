import CommonConstants from './CommonConstants'

@Styles function text() {
  .borderWidth(0)
  .borderColor(Color.Transparent)
  .margin({bottom: 24})
  .borderRadius(0)
}
  @Styles  function pageDefault() {
    .height('100%')
    .backgroundColor(CommonConstants.THEME_COLOR_BACKGROUND)

  }
// @Extends(Button) commonStyle() {
//
// }