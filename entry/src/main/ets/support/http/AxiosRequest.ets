//AxiosRequest.ets
import { AxiosHttpRequest, errorHandler } from './AxiosHttp'
import { AxiosError, AxiosRequestHeaders } from '@ohos/axios';
import Logger from '../../utils/Logger';

// import showToast from '../utils/ToastUtils';
// import { hideLoadingDialog, showLoadingDialog } from '../utils/DiaLogger';
// import { StorageUtils } from '../utils/StorageUtils';
// import { StorageKeys } from '../constants/StorageKeys';
// import { JsonUtils } from '../utils/JsonUtils';
// import { Router } from '../route/Router';
// import { RoutePath } from '../route/RoutePath';

const BASE_URL = 'https://www.wanandroid.com'
/**
 * axios请求客户端创建
 */
const axiosClient = new AxiosHttpRequest({
  baseURL: BASE_URL, //"/api",
  timeout: 10 * 1000,
  checkResultCode: false,
  headers: {
    'Content-Type': 'application/json'
  } as AxiosRequestHeaders,
  interceptorHooks: {
    requestInterceptor: async (config) => {
      // 在发送请求之前做一些处理，例如打印请求信息
      Logger.debug('网络请求Request 请求方法:', `${config.method}`);
      Logger.debug('网络请求Request 请求链接:', `${config.url}`);
      Logger.debug('网络请求Request Params:', `\n${JSON.stringify(config.params)}`);
      Logger.debug('网络请求Request Data:', `${JSON.stringify(config.data)}`);
      axiosClient.config.showLoading = config.showLoading
      if (config.showLoading) {
        // showLoadingDialog("加载中...")
      }
      // if (config.checkLoginState) {
      //   let hasLogin = await StorageUtils.get(StorageKeys.USER_LOGIN, false)
      //   Logger.debug('网络请求Request 登录状态校验>>>', `${hasLogin.toString()}`);
      //   if (hasLogin) {
      //     return config
      //   } else {
      //     if (config.needJumpToLogin) {
      //       Router.push(RoutePath.TestPage)
      //     }
      //     throw new AxiosError("请登录")
      //   }
      // }
      return config;
    },
    requestInterceptorCatch: (err) => {
      Logger.error("网络请求RequestError", err.toString())
      if (axiosClient.config.showLoading) {
        // hideLoadingDialog()
      }
      return err;
    },
    responseInterceptor: (response) => {
      // Logger.error("showToast", JSON.stringify(response));
      //优先执行自己的请求响应拦截器，在执行通用请求request的
      if (axiosClient.config.showLoading) {
        // hideLoadingDialog()
      }
      Logger.debug('网络请求响应Response:', `\n${JSON.stringify(response.data)}`);
      if (response.status === 200) {
        // @ts-ignore
        const checkResultCode = response.config.checkResultCode
        if (checkResultCode && response.data.errorCode != 0) {
          // showToast(response.data.errorMsg)
          return Promise.reject(response)
        }
        return Promise.resolve(response.data);
      } else {
        return Promise.reject(response);
      }
    },
    responseInterceptorCatch: (error) => {
      if (axiosClient.config.showLoading) {
        // hideLoadingDialog()
      }
      Logger.error("网络请求响应异常", error.toString())
      errorHandler(error);
      return Promise.reject(error);
    },
  }
});

export default axiosClient;