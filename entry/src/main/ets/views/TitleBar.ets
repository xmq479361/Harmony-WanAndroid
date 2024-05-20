import router from '@ohos.router';
import CommonConstants from '../global/CommonConstants';
import { Resources } from '../global/Resources';

export interface TitleItemValue {
  str?: string
  icon?: string | PixelMap | Resource
}

@Builder
export function buildItemView(value: TitleItemValue, textAlign: TextAlign) {
  if (value) {
    if (value.str && value.str.length > 0) {
      Text(value.str)
        .width('100%')
        .textAlign(textAlign)
        .fontColor($r('app.color.fontColor_text3'))
        .fontSize(15)
        .maxLines(1)
        .fontWeight(FontWeight.Bold)
    } else if (value.icon) {
      Image(value.icon)
        .height('100%')
        .width(32)
        .height(32)
        .padding(6)
    }
  } // else Text('')
}

@Component
export default struct TitleBar {
  // config: TitleConfig = {}
  left: TitleItemValue = {
    icon: Resources.icon_back,
  }
  center?: TitleItemValue
  right?: TitleItemValue
  @BuilderParam titleContentBuilder: () => void = this.defaultTitleBarContentBuilder

  aboutToAppear() {
    console.log("TitleBar aboutToAppear " + JSON.stringify(this.left))
  }

  @Builder
  defaultTitleBarContentBuilder() {
    Row() {
      buildItemView(this.left, TextAlign.Start)
    }
    .height('100%')
    .width(50)
    .onClick(() => {
      // ToastUtils.showToast('routeState: ' + router.getState())
      router.back()
    })

    // .backgroundColor(Color.Red)
    Row() {
      buildItemView(this.center, TextAlign.Center)
    }
    .height('100%')
    .layoutWeight(1)

    Row() {
      buildItemView(this.right, TextAlign.End)
    }
    .height('100%')
    .justifyContent(FlexAlign.End)
    .width(50)
  }

  build() {
    Column() {
      Row() {
        this.titleContentBuilder()
      }
      .padding({ left: CommonConstants.PADDING_HORIZONTAL,
        right: CommonConstants.PADDING_HORIZONTAL,
        top: CommonConstants.PADDING_VERTICAL,
        bottom: CommonConstants.PADDING_VERTICAL })
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height(CommonConstants.TITLE_BAR_HEIGHT)
      .width('100%')

      Divider().height(0.4).color($r('app.color.lightest_gray'))
    }
    .backgroundColor($r('app.color.light_color'))
    .zIndex(100)
  }
}

//
// // declare type TitleItemValue = string | PixelMap | Resource | CustomBuilder
// // // interface TitleConfig {
// // //   left: TitleItemValue
// // //   center: TitleItemValue
// // //   left: TitleItemValue
// // // }
// //
// // @Component
// // struct TitleItem {
// //   @Prop value?: TitleItemValue
// //
// //   build() {
// //     if (this.value) {
// //       // if (isString(this.value)) {
// //       //
// //       // }
// //       switch (typeof this.value) {
// //         case 'string':
// //           Text(this.value as string)
// //           break;
// //         // case PixelMap
// //         case 'object':
// //           Image(this.value as Resource)
// //           break;
// //       }
// //     } else {
// //       Text('')
// //     }
// //   }
// // }
// @Component
// export  struct TitleBarLeft {
//   @BuilderParam child: () => {}
//   build() {
//     this.child()
//   }
// }
// @Component
// export struct TitleBar {
//   // @Prop config: TitleConfig
//   // @Prop left: TitleItemValue
//   // @Prop center: TitleItemValue
//   // @Prop right: TitleItemValue
//   @BuilderParam left: () => {}
//   @BuilderParam center: () => {}
//   @BuilderParam right: (() => {})[]
//   build() {
//     Row() {
//       Row() {
//         this.left()
//       }.layoutWeight(1)
//       Row() {
//         this.center()
//       }.layoutWeight(1)
//       Row() {
//         // ForEach(this.right, (builder: ()=>{}, index: number)=>{
//         //   builder.bind(this)
//         // })
//       }.layoutWeight(1)
//       // TitleItem({value: this.left})
//       // TitleItem({value: this.center})
//       // TitleItem({value: this.right})
//
//     }
//     .padding({ left: CommonConstants.PADDING_HORIZONTAL,
//       right: CommonConstants.PADDING_HORIZONTAL,
//       top: CommonConstants.PADDING_VERTICAL,
//       bottom: CommonConstants.PADDING_VERTICAL })
//     .justifyContent(FlexAlign.SpaceBetween)
//     .height(CommonConstants.TITLE_BAR_HEIGHT)
//     .width('100%')
//   }
// }
//
