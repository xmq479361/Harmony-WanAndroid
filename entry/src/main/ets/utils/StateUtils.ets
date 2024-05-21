import ListState, { ListStateInterface } from '../component/ptr/ListState';
import PageList from '../model/ArticleList';

export function calculateState<T>(pageSize:number, srcData: T[], newData: PageList<T>) : ListStateInterface {
  let newDataLen = newData.datas?.length
  if (srcData.length == 0 && newDataLen == 0) {
    return ListState.NoData
  }
  // srcData.push(...newData.datas)
  if (newDataLen >= pageSize) {
    return ListState.HasMore
  } else if (newDataLen > 0 && newData.curPage < newData.pageCount) {
    return ListState.HasMore
  } else {
    return ListState.NoMore
  }
}