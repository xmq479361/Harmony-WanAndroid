import WanAndroidService from '../../api/WanAndroidService';
import { ProjectTabItem } from '../../model/ProjectVO';
import PageState from '../../model/vo/PageState';
import CommonConstants from '../../global/CommonConstants';
import ProjectSubList from './ProjectSubList';

@Extend(Text)
function styleForTabSelect(isSelected: boolean) {
  .fontColor(isSelected ? Color.Green : Color.Gray)
  .fontSize(isSelected ? CommonConstants.FONT_SIZE_NORMAL_X : CommonConstants.FONT_SIZE_NORMAL)
}

@Preview
@Component
export default struct ProjectTabContent {
  private controller: TabsController = new TabsController()
  @State pageState: PageState = PageState.Initial;
  @State projectTabs: ProjectTabItem[] = [];
  @State currentIndex: number = 0;
  @State activeIndex: number[] = [this.currentIndex];

  @Builder
  TabBuilder(index: number, title: string) {
    Text(title)
      .padding(CommonConstants.DEFAULT_10)
      .styleForTabSelect(index == this.currentIndex)
  }

  build() {
    Tabs({ barPosition: BarPosition.Start,
      controller: this.controller, index: this.currentIndex }) {
      if (this.projectTabs.length > 0) {
        ForEach(this.projectTabs, (item, index) => {
          TabContent() {
            if (this.activeIndex.includes(index)) {
              ProjectSubList({ cid: item.id })
            }
          }.tabBar(this.TabBuilder(index, item.name))
        })
      }
    }
    .animationDuration(200)
    .scrollable(true)
    .barMode(BarMode.Scrollable)
    .barHeight(CommonConstants.DEFAULT_56)

    .onChange((index) => {
      if (!this.activeIndex.includes(index)) {
        this.activeIndex.push(index)
      }
      console.log('project: ', index)
      this.currentIndex = index;
    })
    .layoutWeight(1)
    .height(CommonConstants.THOUSANDTH_1000)
    .backgroundColor(CommonConstants.THEME_COLOR_BACKGROUND)
  }

  aboutToAppear() {
    this.getProjectTree();
  }

  async getProjectTree() {
    this.pageState = PageState.Loading
    try {
      let response = await WanAndroidService.getProjectTree()
      console.log("getProjectTree: ", JSON.stringify(response));
      this.projectTabs = response.data
      console.log("projectTabs>>: ", JSON.stringify(this.projectTabs));
      this.pageState = PageState.Success
    } catch (e) {
      console.log("getProjectTree error", e)
      this.pageState = PageState.Failed
    }
  }
}