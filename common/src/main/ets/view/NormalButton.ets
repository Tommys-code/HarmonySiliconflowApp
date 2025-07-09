@ComponentV2
export struct NormalButton {
  @Param buttonOptions: NormalButtonOptions = new NormalButtonOptions()

  build() {
    Button({
      type: ButtonType.ROUNDED_RECTANGLE
    }) {
      Text(this.buttonOptions.text)
        .padding({ top: 8, bottom: 8 })
        .fontColor(this.buttonOptions.textColor)
        .width('100%')
        .textAlign(TextAlign.Center)
    }
    .borderRadius(this.buttonOptions.radius)
    .enabled(this.buttonOptions.enable)
    .backgroundColor(this.buttonOptions.color)
    .layoutWeight(1)
    .onClick(this.buttonOptions.click)
  }
}

export class NormalButtonOptions {
  text: string | Resource = ''
  textColor: ResourceColor = $r('app.color.primary_text')
  radius: Length | BorderRadiuses | LocalizedBorderRadiuses = 10
  enable: boolean = true
  color: ResourceColor = $r('app.color.background_l1')
  click: () => void = () => {
  }

  setText(text: string | Resource): NormalButtonOptions {
    this.text = text
    return this
  }

  setTextColor(textColor: ResourceColor): NormalButtonOptions {
    this.textColor = textColor
    return this
  }

  setRadius(radius: Length | BorderRadiuses | LocalizedBorderRadiuses): NormalButtonOptions {
    this.radius = radius
    return this
  }

  isEnable(enable: boolean): NormalButtonOptions {
    this.enable = enable
    return this
  }

  setColor(color: ResourceColor): NormalButtonOptions {
    this.color = color
    return this
  }

  onClick(click?: () => void): NormalButtonOptions {
    this.click = click ?? (() => {
    })
    return this
  }
}
