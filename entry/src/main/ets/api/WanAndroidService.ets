import BannerVO from '../model/BannerVO'

import AxiosHttpRequest, { ApiResponse } from '../support/http/AxiosHttp'
import axiosClient from '../support/http/AxiosRequest'
import ArticleList from '../model/ArticleList'
import { TreeData } from '../model/TreeData'
import UserModel from '../model/UserModel'
import { NavigationItem } from '../model/NavigationVO'
import HotKey from '../model/SearchVO'

class WanAndroidService {
  // axiosRequest: AxiosHttpRequest = new AxiosHttpRequest({
  //   showLoading: false, //是否展示请求loading
  //   checkResultCode: true, //是否检验响应结果码
  //   checkLoginState: false, //校验用户登陆状态
  //   needJumpToLogin: false, //是否需要跳转到登陆页面
  //
  //   // interceptorHooks: InterceptorHooks,
  //   // headers: AxiosRequestHeaders
  // })

  // async getBanner(): Promise<BannerVO[]> {
  //   return this.axiosRequest.get({
  //     url: '/banner/json',
  //     timeout: 5000
  //   })
  // }

  /**
   * 获取wanAndroid首页Banner数据，测试校验API data：T泛型数据
   * @returns
   */
  getWanAndroidBanner(): Promise<ApiResponse<BannerVO[]>> {
    return axiosClient.get<ApiResponse<BannerVO[]>>(
      {
        url: "/banner/json",
        // baseURL: WanAndroidService.BASE_URL
        // url: "/banner/json",
      }
    );
  }

  // /**
  //  * @returns
  //  */
  // getArticleList(count: number): Promise<ApiResponse<ArticleList>> {
  //   return axiosClient.get<ApiResponse<ArticleList>>(
  //     {
  //       url: `/article/list/${count}/json`,
  //       // checkResultCode: true,
  //       // showLoading: true
  //     }
  //   );
  // }


  /**
   * @returns
   */
  getArticleList(count: number, cid?: number): Promise<ApiResponse<ArticleList>> {
    let params = {}
    if (cid) {
      params['cid'] = cid
    }
    console.log("getArticleList", cid, count)
    return axiosClient.get<ApiResponse<TreeData>>(
      {
        url: `/article/list/${count}/json`,
        params: params
        // checkResultCode: true,
        // showLoading: true
      }
    );
  }

  /**
   * @returns
   */
  getTreeList(): Promise<ApiResponse<TreeData>> {
    return axiosClient.get<ApiResponse<TreeData>>(
      {
        url: `/tree/json`,
        // checkResultCode: true,
        // showLoading: true
      }
    );
  }

  /**
   * @returns
   */
  getNavigationList(): Promise<ApiResponse<NavigationItem[]>> {
    return axiosClient.get<ApiResponse<NavigationItem[]>>(
      {
        url: `/navi/json`,
      }
    );
  }

  /**
   * @returns
   */
  getHotKey(): Promise<ApiResponse<HotKey[]>> {
    return axiosClient.get<ApiResponse<HotKey[]>>(
      {
        url: `/hotkey/json`,
      }
    );
  }

  /**
   * @returns
   */
  search(pageNo: number, searchKey: string): Promise<ApiResponse<ArticleList>> {
    return axiosClient.post<ApiResponse<ArticleList>>(
      {
        url: `/article/query/${pageNo}/json`,
        params: {
          k: searchKey
        }
      }
    );
  }

  /**
   * @returns
   */
  login(name: string, password: string): Promise<ApiResponse<UserModel>> {
    return axiosClient.post<ApiResponse<UserModel>>(
      {
        url: `/user/login`,
        params: {
          username: name,
          password: password
        }
        // checkResultCode: true,
        // showLoading: true
      }
    );
  }
}


const wanAndroidService = new WanAndroidService();

export default wanAndroidService as WanAndroidService;