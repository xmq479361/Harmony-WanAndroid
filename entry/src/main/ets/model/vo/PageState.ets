

export  enum PageState {
  Initial,
  Loading,
  Success,
  Failed,
  Empty,
}



export interface ListState {
  canLoadMore(): boolean
  toString(): string
}


export const NoMore: ListState = {
  canLoadMore() {
    return false
  },
  toString() {
    return 'NoMore'
  }
}
export const HasMore: ListState = {
  canLoadMore() {
    return true
  },
  toString() {
    return 'HasMore'
  }
}
export const NoData: ListState = {
  canLoadMore() {
    return false
  },
  toString() {
    return 'NoData'
  }
}
export const Loading: ListState = {
  canLoadMore() {
    return false
  },
  toString() {
    return 'Loading'
  }
}


export  module ListState {
  export type ListState = {
    NoData
  }
}
