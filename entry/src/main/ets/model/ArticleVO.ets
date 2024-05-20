export default class ArticleVO {
  niceDate: string
  title: string
  desc: string
  author: string
  shareUser: string
  id: number
  chapterName: string
  link: String
} {
}

ArticleVO.toString = function() {
  console.log("article toString:", this.title)
  return this.title
}