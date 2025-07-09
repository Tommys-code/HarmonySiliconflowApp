@ComponentV2
export struct NormalButton {
  @Param text: string | Resource = ''
  @Param textColor: ResourceColor = $r('app.color.primary_text')
  @Param radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 10
  @Param enable: boolean = true
  @Param color: ResourceColor = $r('app.color.background_l1')
  @Param borderOptions?: BorderOptions = undefined
  @Event click: () => void = () => {
  }
  @Param weight?: number = undefined

  build() {
    Button(this.text, {
      type: ButtonType.ROUNDED_RECTANGLE
    })
      .fontColor(this.textColor)
      .borderRadius(this.radius)
      .enabled(this.enable)
      .backgroundColor(this.color)
      .borderWidth(this.borderOptions?.width)
      .borderColor(this.borderOptions?.color)
      .onClick(() => {
        this.click()
      })
      .layoutWeight(this.weight)
  }
}
