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
  static TitleLarge: TextStyleModifier = new TextStyleModifier({ fontSize: 22 })
}