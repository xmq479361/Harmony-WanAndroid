import ArticleVO from './ArticleVO'

export default class PageList<T> {
  curPage: number
  offset: number
  pageCount: number
  size: number
  total: number
  over: boolean
  datas: T[]
}
    