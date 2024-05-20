import promptAction from '@ohos.promptAction'
import CommonConstants from '../global/CommonConstants'
/**
 * Toast工具类
 *
 */
class ToastUtils {
  showToast(msg: string | Resource): void {
    promptAction.showToast({
      message: msg,
      duration: CommonConstants.TOAST_DURATION
    })
  }

  //提示框：长时间
  showToastLong(msg: string | Resource): void {
    promptAction.showToast({
      message: msg,
      duration: CommonConstants.TOAST_LONG_DURATION
    })
  }
}

export default new ToastUtils()