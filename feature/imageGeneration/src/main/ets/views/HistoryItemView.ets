import { Style } from "common"
import { LengthMetrics } from "@kit.ArkUI"
import { ImageCreationHistory } from "common/src/main/ets/db/entity/ImageCreationHistory";

@ComponentV2
export struct HistoryItemView {
  @Param history?: ImageCreationHistory = undefined
  private mutableStyledString: MutableStyledString = new MutableStyledString('')
  private controller: TextController = new TextController();

  aboutToAppear(): void {
    if (this.history) {
      this.mutableStyledString
        .appendStyledString(new MutableStyledString(this.history.prompt))
      this.mutableStyledString
        .appendStyledString(new MutableStyledString(this.history.ratio.desc, [
          {
            start: 0,
            length: this.history.ratio.desc.length,
            styledKey: StyledStringKey.FONT,
            styledValue: new TextStyle({
              fontSize: LengthMetrics.vp(Style.LabelSmallSize)
            })
          }
        ]))
      this.controller.setStyledString(this.mutableStyledString)
    }
  }

  build() {
    Column() {
      Text(undefined, { controller: this.controller }).attributeModifier(Style.BodyLarge)
    }
  }
}