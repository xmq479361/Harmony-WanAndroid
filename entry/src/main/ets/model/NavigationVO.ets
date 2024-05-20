export class NavigationItemDetail {
  id: number
  link: string
  title: string
  chapterId: number
}

export class NavigationItem {
  cid: number
  name: string
  isSelected: boolean
  articles: NavigationItemDetail[]
}