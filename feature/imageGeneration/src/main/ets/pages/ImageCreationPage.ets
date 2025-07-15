import { navigationTitle } from "common";

@ComponentV2
struct ImageCreationPage {
  @Consumer('pageStack') pageStack: NavPathStack = new NavPathStack()

  build() {
    NavDestination() {

    }
    .title(navigationTitle($r('[common].string.image_creation_title'), () => this.pageStack.pop()))
    .hideBackButton(true)
  }
}

@Builder
export function ImageCreationPageBuilder() {
  ImageCreationPage();
}