export class ImageRatio {
  static readonly RATIO_1_1 = new ImageRatio("1024x1024", 1.0, "1:1");
  static readonly RATIO_1_2 = new ImageRatio("1024x2048", 0.5, "1:2");
  static readonly RATIO_3_2 = new ImageRatio("1536x1024", 1.5, "3:2");
  static readonly RATIO_3_4 = new ImageRatio("1536x2048", 0.75, "3:4");
  static readonly RATIO_16_9 = new ImageRatio("2048x1152", 16 / 9, "16:9");
  static readonly RATIO_9_16 = new ImageRatio("1152x2048", 9 / 16, "9:16");
  private static readonly ratios = [
    ImageRatio.RATIO_1_1,
    ImageRatio.RATIO_1_2,
    ImageRatio.RATIO_3_2,
    ImageRatio.RATIO_3_4,
    ImageRatio.RATIO_16_9,
    ImageRatio.RATIO_9_16,
  ]
  readonly value: string
  readonly size: number
  readonly desc: string

  private constructor(value: string, size: number, desc: string) {
    this.value = value
    this.size = size
    this.desc = desc
  }

  static fromValue(value: string | null): ImageRatio {
    return ImageRatio.ratios.find((ratio) => ratio.value === value) ?? ImageRatio.RATIO_1_1
  }
}