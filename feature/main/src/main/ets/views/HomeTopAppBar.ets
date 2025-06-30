@ComponentV2
export struct HomeTopAppBar {
  @Event toggleDrawer: () => void = () => {
  };

  @Builder
  Title() {
    Stack({ alignContent: Alignment.Center }) {
      Row() {

      }.layoutWeight(1)
    }.layoutWeight(1)
  }

  build() {
    Row() {
      Image($r('[common].media.ic_dehaze'))
        .height(36)
        .width(36)
        .fillColor($r('[common].color.icon'))
        .onClick(() => {
          this.toggleDrawer()
        })
      this.Title()
      Image($r('[common].media.ic_circle_add'))
        .height(36)
        .width(36)
        .fillColor($r('[common].color.icon'))
    }
    .height(64)
    .width('100%')
    .padding({ left: 16, right: 16 })
  }
}
