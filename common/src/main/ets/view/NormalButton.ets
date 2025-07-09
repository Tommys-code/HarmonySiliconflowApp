@ComponentV2
export struct NormalButton {
  @Param text: string | Resource = ''
  @Param textColor: ResourceColor = $r('app.color.primary_text')
  @Param radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 10
  @Param enable: boolean = true
  @Param color: ResourceColor = $r('app.color.background_l1')
  @Event click: () => void = () => {
  }

  build() {
    Button({
      type: ButtonType.ROUNDED_RECTANGLE
    }) {
      Text(this.text)
        .padding({ top: 8, bottom: 8 })
        .fontColor(this.textColor)
        .width('100%')
        .textAlign(TextAlign.Center)
    }
    .borderRadius(this.radius)
    .enabled(this.enable)
    .backgroundColor(this.color)
    .layoutWeight(1)
    .onClick(() => {
      this.click()
    })
  }
}
