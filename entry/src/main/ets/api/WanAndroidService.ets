import BannerVO from '../model/BannerVO'

import AxiosHttpRequest, { ApiResponse } from '../support/http/AxiosHttp'
import axiosClient from '../support/http/AxiosRequest'
import PageList from '../model/ArticleList'
import { TreeData } from '../model/TreeData'
import UserModel from '../model/UserModel'
import { NavigationItem } from '../model/NavigationVO'
import HotKey from '../model/SearchVO'
import { ProjectPageItem, ProjectTabItem } from '../model/ProjectVO'
import ArticleVO from '../model/ArticleVO'

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
  getArticleList(count: number, pageSize: number, cid?: number): Promise<ApiResponse<PageList<ArticleVO>>> {
    let params = { page_size: pageSize }
    if (cid) {
      params['cid'] = cid
    }
    console.log("getArticleList", cid, count)
    return axiosClient.get<ApiResponse<PageList<ArticleVO>>>(
      {
        url: `/article/list/${count}/json`,
        params: params
      }
    );
  }

  /**
   * @returns
   */
  getTreeList(): Promise<ApiResponse<TreeData>> {
    return axiosClient.get<ApiResponse<TreeData>>(
      {
        url: `/tree/json`
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
  search(pageNo: number, searchKey: string): Promise<ApiResponse<PageList<ArticleVO>>> {
    return axiosClient.post<ApiResponse<PageList<ArticleVO>>>(
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

  /**
   * @returns
   */
  getProjectTree(): Promise<ApiResponse<ProjectTabItem>> {
    return axiosClient.get<ApiResponse<ProjectTabItem>>(
      {
        url: `/project/tree/json`
      }
    );
  }

  /**
   * @returns
   */
  getProjectItemList(count: number, pageSize: number, cid: number): Promise<ApiResponse<ProjectPageItem>> {
    return axiosClient.get<ApiResponse<ProjectPageItem>>(
      {
        url: `/project/list/${count}/json`,
        params: {
          cid: cid,
          page_size: pageSize
        }
      }
    );
  }
}


const wanAndroidService = new WanAndroidService();

export default wanAndroidService as WanAndroidService;