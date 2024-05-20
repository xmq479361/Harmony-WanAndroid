import ArticleVO from './ArticleVO'

export default class ArticleList {
  curPage: number
  offset: number
  pageCount: number
  size: number
  total: number
  over: boolean
  datas: ArticleVO[]
}
    