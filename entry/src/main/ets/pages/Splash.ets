@ComponentV2
export struct Splash {
  build() {
    Stack() {
      Image($r('app.media.ic_silicon_flow'))
        .height(200)
        .objectFit(ImageFit.Cover)
    }.alignContent(Alignment.Center)
    .height('100%')
    .width('100%')
  }
}