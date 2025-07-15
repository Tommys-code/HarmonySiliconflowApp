interface ImageStyleInterface {
  size: number
}

export class ImageStyleModifier implements AttributeModifier<ImageAttribute> {
  private style: ImageStyleInterface;

  constructor(style: ImageStyleInterface) {
    this.style = style;
  }

  applyNormalAttribute(node: ImageAttribute): void {
    node
      .width(this.style.size)
      .height(this.style.size)
      .fillColor($r('app.color.icon'))
  }
}

export class ImageStyle {
  static Normal: ImageStyleModifier = new ImageStyleModifier({ size: 36 })
  static Medium: ImageStyleModifier = new ImageStyleModifier({ size: 32 })
  static Small: ImageStyleModifier = new ImageStyleModifier({ size: 24 })
}