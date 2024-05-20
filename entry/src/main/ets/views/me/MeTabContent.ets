import router from '@ohos.router'
import CommonConstants from '../../global/CommonConstants'
import { Resources } from '../../global/Resources'
import PreferenceUtil from '../../utils/PreferenceUtil'

@Component
export default struct MeTabContent {
  @StorageLink('userName') nickName: string = ''

  goLogin() {
    router.pushUrl({
      url: "pages/LoginPage",
    });
  }

  promptLogout() {
    AlertDialog.show({
      title: "提示？", //弹窗标题
      message: '是否退出登录？', // 提示消息
      autoCancel: true, // 点击遮罩层即阴影，是否关闭弹窗。true是点击遮罩层弹窗关闭。
      alignment: DialogAlignment.Bottom, //弹窗位置
      offset: { dx: 0, dy: -30 }, // 相对弹窗位置即DialogAlignment.Bottom 在x轴和y轴偏移
      primaryButton: {
        value: "确定",
        fontColor: Color.Red,
        action: () => {
          AppStorage.SetOrCreate(CommonConstants.K_USER_NAME, '')
          PreferenceUtil.putPreferenceValue("userName", '');
          this.goLogin();
        }
      },
      secondaryButton: {
        value: "取消",
        action: () => {
        }
      }
    })
  }

  build() {
    Scroll() {
      Column() {
        Stack() {
          Image(Resources.bg)
            .height(210)
            .width('100%')
            .objectFit(ImageFit.Fill)
          Text(this.nickName?.length > 0 ? this.nickName : "登录")
            .fontSize(16)
            .position({
              x: 30, y: 105
            })
            .height(40)
            .width(100)
            .onClick(() => {
              if (this.nickName.length > 0) {
                this.promptLogout()
              } else {
                this.goLogin();
              }
            })
        }

        Row() {
          Text('我的收藏')
        }
        .height(60)
        .backgroundColor(Color.White)
        .padding(10)
        .width('100%')
        .margin({ top: 20 })

        Divider().height(1)
        Row() {
          Text('关于我们')
        }
        .height(60)
        .backgroundColor(Color.White)
        .padding(10)
        .width('100%')
      }
      .justifyContent(FlexAlign.Start)
      .height('100%')
      .backgroundColor(CommonConstants.THEME_COLOR_BACKGROUND)
    }
  }
}