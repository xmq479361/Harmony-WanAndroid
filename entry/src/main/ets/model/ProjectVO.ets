export class ProjectTabItem {
  id: number
  name: String
}

export class ProjectItemSub {
  id: number
  author: string
  desc: string
  envelopePic: string
  link: string
  niceDate: string
  title: string
  shareUser: String
}


export class ProjectPageItem {
  datas: ProjectItemSub[]
}