interface TextStyle {
  fontSize: number
}

export class TextStyleModifier implements AttributeModifier<TextAttribute> {
  private style: TextStyle;

  constructor(style: TextStyle) {
    this.style = style;
  }

  applyNormalAttribute(node: TextAttribute): void {
    node.fontSize(this.style.fontSize);
  }
}

export class Style {
  static TitleLargeSize = 22
  static TitleMediumSize = 16
  static BodyMediumSize = 14
  static TitleLarge: TextStyleModifier = new TextStyleModifier({ fontSize: Style.TitleLargeSize })
  static TitleMedium: TextStyleModifier = new TextStyleModifier({ fontSize: Style.TitleMediumSize })
  static BodyMedium: TextStyleModifier = new TextStyleModifier({ fontSize: Style.BodyMediumSize })
}