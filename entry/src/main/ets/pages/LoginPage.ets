import router from '@ohos.router'
import WanAndroidService from '../api/WanAndroidService'
import CommonConstants from '../global/CommonConstants'
import PreferenceUtil from '../utils/PreferenceUtil'
import ToastUtils from '../utils/ToastUtils'

@Styles
function inputText() {
  .borderWidth(0)
  .borderColor(Color.Transparent)
  .margin({ bottom: 24 })
  .borderRadius(0)
}

@Entry
@Component
struct LoginPage {
  @State message: string = 'Hello World'
  private pwdController: TextInputController = new TextInputController()
  private userNameController: TextInputController = new TextInputController()
  @State private username: string = ''
  @State private password: string = ''

  build() {
    Column() {
      Column() {
        Text('登录')
          .fontSize(50)
          .fontColor(Color.Gray)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 50 })
        TextInput({
          controller: this.userNameController,
          placeholder: "请输入用户名",
          text: "xmqyeah"
        })
          .borderRadius(0)
          .inputText()
          .onChange((value: string) => this.username = value)
        Row() {
          TextInput({
            controller: this.pwdController,
            placeholder: "请输入密码",
            text: "Xmqyeah163Com"
          })
            .inputText()
            .type(InputType.Password)
            .onChange((value: string) => this.password = value)
        }

        Button({ type: ButtonType.Normal }) {
          Text('登录')
            .fontSize(16)
            .fontColor(Color.White)
        }
        .width('100%')
        .padding(10)
        .margin({ top: 24 })
        .borderRadius(0)
        .onClick(() => this.login())

        Button() {
          Text('还没账号?点此注册')
            .fontSize(12)
            .fontColor('#2A2')
        }
        .width('100%')
        .backgroundColor(Color.Transparent)
        .margin({ top: 20 })
      }
      .padding(20)
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Text('www.android.com')
        .fontSize(12)
        .height(40)
        .fontColor('#AAA')
    }.height('100%')
  }

  async login() {
    if (this.username.length == 0) {
      ToastUtils.showToast("用户名不能为空")
      return
    } else if (this.password.length < 6) {
      ToastUtils.showToast("密码不能小于6位")
      return
    }
    let response = await WanAndroidService.login(this.username, this.password)
    console.log("login:", response.data.nickname, JSON.stringify(response));
    if (response.errorCode == 0 && response.data){
      await PreferenceUtil.putPreferenceValue("user", response.data)
      await PreferenceUtil.putPreferenceValue("userName", response.data.nickname)
      AppStorage.SetOrCreate(CommonConstants.K_USER_NAME, response.data.nickname)
      router.back({
        url: "pages/HomePage",
        params: {
          result: true
        }
      })
    }
  }
}