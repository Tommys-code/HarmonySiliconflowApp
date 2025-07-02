@ComponentV2
export struct ThreeDotLoading {
  @Param @Once dotCount: number = 3;
  @Param @Once delayPerDot: number = 200; // 毫秒
  @Local dotAlphas: number[] = [];

  aboutToAppear() {
    // 初始化每个点的透明度值
    for (let i = 0; i < this.dotCount; i++) {
      this.dotAlphas = [0.2, 0.2, 0.2]
    }
  }

  build() {
    Row() {
      ForEach(Array(this.dotCount).fill(0), (item: number, index: number) => {
        Circle()
          .margin({ right: 4 })
          .width(8)
          .height(8)
          .fill($r('app.color.icon'))
          .opacity(this.dotAlphas[index])
          .animation({
            duration: this.dotCount * this.delayPerDot * 2,
            delay: index * this.delayPerDot,
            iterations: -1,
            curve: Curve.Friction,
            playMode: PlayMode.Reverse,
          })
          .onAppear(() => {
            this.dotAlphas = [0.8, 0.8, 0.8]
          })
      })
    }
  }
}
