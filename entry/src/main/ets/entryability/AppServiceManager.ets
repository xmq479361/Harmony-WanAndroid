import webview from '@ohos.web.webview';
import PreferenceUtil from '../utils/PreferenceUtil';

class ServiceManager {
  initialized(context) {
    PreferenceUtil.loadPreference(context)
    // 通过WebviewController可以控制Web组件各种行为。一个WebviewController对象只能控制一个Web组件，且必须在Web组件和WebviewController绑定后，才能调用WebviewController上的方法（静态方法除外）。
    webview.WebviewController.initializeWebEngine();

  }
}

const AppServiceManager = new ServiceManager()

export default AppServiceManager